insert into public.profiles (id, user_key, full_name, title, role, can_view_reports, is_active)
select
    au.id,
    seed.user_key,
    seed.full_name,
    seed.title,
    seed.role::app_role,
    seed.can_view_reports,
    true
from auth.users au
join (
    values
        ('o.aslan@metaendustri.com.tr', 'omer', 'Ömer Aslan', 'Satış Müdürü', 'admin', true),
        ('k.kafdal@metaendustri.com.tr', 'kenan', 'Kenan Kafdal', 'Satış Direktörü', 'director', true),
        ('h.oznal@metaendustri.com.tr', 'remzi', 'Remzi Hamdi Özkan', 'Satış', 'sales', false),
        ('h.arici@metaendustri.com.tr', 'hakan', 'Hakan Arıcı', 'Satış', 'sales', false),
        ('m.tanka@metaendustri.com.tr', 'merve', 'Merve Tanka', 'Proje', 'project', false)
) as seed(email, user_key, full_name, title, role, can_view_reports)
    on lower(au.email) = lower(seed.email)
on conflict (id) do update
set
    user_key = excluded.user_key,
    full_name = excluded.full_name,
    title = excluded.title,
    role = excluded.role,
    can_view_reports = excluded.can_view_reports,
    is_active = excluded.is_active;
