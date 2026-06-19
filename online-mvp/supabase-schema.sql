create extension if not exists pgcrypto;

create type app_role as enum ('admin', 'director', 'sales', 'project');
create type customer_status as enum ('Aktif', 'Potansiyel', 'Pasif');
create type opportunity_type as enum ('Satış', 'Teklif', 'Numune', 'Şikayet', 'Bağlantı', 'Ziyaret', 'Ürün Bilgisi', 'Proje Görüşmesi');
create type quote_status as enum ('Taslak', 'Gönderildi', 'Beklemede', 'Kabul Edildi', 'Reddedildi', 'İptal');
create type task_priority as enum ('Düşük', 'Orta', 'Yüksek', 'Kritik');
create type task_status as enum ('Açık', 'Devam Ediyor', 'Beklemede', 'Tamamlandı', 'Ertelendi', 'İptal Edildi');
create type project_status as enum ('Hazırlık', 'Onay Bekliyor', 'Üretimde', 'Sevkiyat Planlandı', 'Kısmi Teslim', 'Tamamlandı', 'Askıda');

create table if not exists public.profiles (
    id uuid primary key references auth.users(id) on delete cascade,
    user_key text unique not null,
    full_name text not null,
    title text,
    role app_role not null default 'sales',
    can_view_reports boolean not null default false,
    is_active boolean not null default true,
    created_at timestamptz not null default now()
);

create table if not exists public.customers (
    id uuid primary key default gen_random_uuid(),
    legacy_id text unique,
    name text not null,
    city text,
    phone text,
    tax_office text,
    tax_no text,
    status customer_status not null default 'Potansiyel',
    notes text,
    owner_id uuid references public.profiles(id) on delete set null,
    created_by uuid references public.profiles(id) on delete set null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists public.opportunities (
    id uuid primary key default gen_random_uuid(),
    legacy_id text unique,
    customer_id uuid references public.customers(id) on delete set null,
    owner_id uuid references public.profiles(id) on delete set null,
    name text not null,
    type opportunity_type not null default 'Satış',
    source text,
    stage text not null,
    amount numeric(14,2) not null default 0,
    probability integer not null default 0,
    close_date date,
    competitor text,
    notes text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists public.quotes (
    id uuid primary key default gen_random_uuid(),
    legacy_id text unique,
    quote_no text not null unique,
    quote_date date not null,
    status quote_status not null default 'Taslak',
    owner_id uuid references public.profiles(id) on delete set null,
    customer_id uuid references public.customers(id) on delete set null,
    opportunity_id uuid references public.opportunities(id) on delete set null,
    revision text default 'R0',
    note text,
    payment_method text,
    city text,
    phone text,
    tax_no text,
    subtotal numeric(14,2) not null default 0,
    vat numeric(14,2) not null default 0,
    total numeric(14,2) not null default 0,
    cancel_reason text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists public.quote_items (
    id uuid primary key default gen_random_uuid(),
    legacy_id text,
    quote_id uuid not null references public.quotes(id) on delete cascade,
    product_type text not null,
    size_label text not null,
    thickness_mm numeric(10,2) not null,
    qty numeric(12,2) not null default 0,
    base_price numeric(14,2) not null default 0,
    unit_price numeric(14,2) not null default 0,
    margin_percent numeric(8,2) not null default 0,
    discount_percent numeric(8,2) not null default 0,
    note text,
    line_total numeric(14,2) not null default 0,
    width_mm numeric(10,2),
    length_mm numeric(10,2),
    volume_m3 numeric(14,6),
    created_at timestamptz not null default now()
);

create table if not exists public.tasks (
    id uuid primary key default gen_random_uuid(),
    legacy_id text unique,
    customer_id uuid references public.customers(id) on delete set null,
    owner_id uuid references public.profiles(id) on delete set null,
    quote_id uuid references public.quotes(id) on delete set null,
    title text not null,
    type text,
    priority task_priority not null default 'Orta',
    status task_status not null default 'Açık',
    due_date date,
    description text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists public.projects (
    id uuid primary key default gen_random_uuid(),
    legacy_id text unique,
    customer_id uuid references public.customers(id) on delete set null,
    owner_id uuid references public.profiles(id) on delete set null,
    name text not null,
    status project_status not null default 'Hazırlık',
    due_date date,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists public.price_rules (
    id uuid primary key default gen_random_uuid(),
    product_type text not null unique,
    price_per_m3 numeric(14,2) not null default 0,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists public.notifications (
    id uuid primary key default gen_random_uuid(),
    legacy_id text unique,
    user_id uuid references public.profiles(id) on delete cascade,
    text text not null,
    type text,
    is_read boolean not null default false,
    created_at timestamptz not null default now()
);

create or replace function public.calculate_volume_m3(
    thickness_mm numeric,
    width_mm numeric,
    length_mm numeric,
    qty numeric
)
returns numeric
language sql
immutable
as $$
    select coalesce((thickness_mm / 1000.0) * (width_mm / 1000.0) * (length_mm / 1000.0) * qty, 0);
$$;

create or replace function public.set_quote_item_volume()
returns trigger
language plpgsql
as $$
begin
    if new.volume_m3 is null then
        new.volume_m3 := public.calculate_volume_m3(new.thickness_mm, new.width_mm, new.length_mm, new.qty);
    end if;
    return new;
end;
$$;

drop trigger if exists trg_quote_items_volume on public.quote_items;
create trigger trg_quote_items_volume
before insert or update on public.quote_items
for each row execute function public.set_quote_item_volume();

create or replace view public.quote_summary as
select
    q.id,
    q.quote_no,
    q.quote_date,
    q.status,
    q.total,
    q.subtotal,
    q.vat,
    q.owner_id,
    q.customer_id,
    coalesce(sum(qi.volume_m3), 0) as total_m3,
    count(qi.id) as item_count
from public.quotes q
left join public.quote_items qi on qi.quote_id = q.id
group by q.id;

create or replace view public.sales_dashboard_summary as
select
    p.id as owner_id,
    p.full_name,
    count(distinct o.id) filter (where o.stage not in ('Tamamlandı', 'İptal Edildi', 'Kapatıldı', 'Gönderildi')) as open_opportunity_count,
    coalesce(sum(o.amount) filter (where o.stage not in ('Tamamlandı', 'İptal Edildi', 'Kapatıldı', 'Gönderildi')), 0) as open_opportunity_amount,
    coalesce(sum(q.total), 0) as total_quote_amount,
    coalesce(sum(case when q.status = 'Kabul Edildi' then q.total else 0 end), 0) as accepted_quote_amount,
    coalesce(sum(case when q.status in ('Reddedildi', 'İptal') then q.total else 0 end), 0) as cancelled_quote_amount,
    coalesce(sum(qs.total_m3), 0) as total_quote_m3,
    coalesce(sum(case when q.status = 'Kabul Edildi' then qs.total_m3 else 0 end), 0) as accepted_quote_m3
from public.profiles p
left join public.opportunities o on o.owner_id = p.id
left join public.quotes q on q.owner_id = p.id
left join public.quote_summary qs on qs.id = q.id
group by p.id, p.full_name;

alter table public.profiles enable row level security;
alter table public.customers enable row level security;
alter table public.opportunities enable row level security;
alter table public.quotes enable row level security;
alter table public.quote_items enable row level security;
alter table public.tasks enable row level security;
alter table public.projects enable row level security;
alter table public.price_rules enable row level security;
alter table public.notifications enable row level security;

create policy "profiles_self_or_report_admin"
on public.profiles
for select
to authenticated
using (
    id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "crm_read_by_owner_or_manager"
on public.customers
for select
to authenticated
using (
    owner_id = auth.uid()
    or created_by = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "crm_write_by_manager_or_owner"
on public.customers
for all
to authenticated
using (
    owner_id = auth.uid()
    or created_by = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
)
with check (
    owner_id = auth.uid()
    or created_by = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "opportunities_read_by_owner_or_manager"
on public.opportunities
for select
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "opportunities_write_by_owner_or_manager"
on public.opportunities
for all
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
)
with check (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "quotes_read_by_owner_or_manager"
on public.quotes
for select
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "quotes_write_by_owner_or_manager"
on public.quotes
for all
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
)
with check (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "quote_items_follow_quote_policy"
on public.quote_items
for all
to authenticated
using (
    exists (
        select 1
        from public.quotes q
        where q.id = quote_id
          and (
              q.owner_id = auth.uid()
              or exists (
                  select 1
                  from public.profiles viewer
                  where viewer.id = auth.uid()
                    and viewer.role in ('admin', 'director')
              )
          )
    )
)
with check (
    exists (
        select 1
        from public.quotes q
        where q.id = quote_id
          and (
              q.owner_id = auth.uid()
              or exists (
                  select 1
                  from public.profiles viewer
                  where viewer.id = auth.uid()
                    and viewer.role in ('admin', 'director')
              )
          )
    )
);

create policy "tasks_read_by_owner_or_manager"
on public.tasks
for select
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "tasks_write_by_owner_or_manager"
on public.tasks
for all
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
)
with check (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "projects_read_by_owner_or_manager"
on public.projects
for select
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "projects_write_by_owner_or_manager"
on public.projects
for all
to authenticated
using (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
)
with check (
    owner_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "price_rules_read_for_authenticated"
on public.price_rules
for select
to authenticated
using (true);

create policy "price_rules_write_for_admin_and_director"
on public.price_rules
for all
to authenticated
using (
    exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
)
with check (
    exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "notifications_read_own_or_manager"
on public.notifications
for select
to authenticated
using (
    user_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);

create policy "notifications_write_own_or_manager"
on public.notifications
for all
to authenticated
using (
    user_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
)
with check (
    user_id = auth.uid()
    or exists (
        select 1
        from public.profiles viewer
        where viewer.id = auth.uid()
          and viewer.role in ('admin', 'director')
    )
);
