# Mevcut CRM'den Online MVP'ye Geçiş Notları

## Mevcut veri kaynakları

Uygulama şu anda şu `localStorage` anahtarlarını kullanıyor:

- `crm_session`
- `crm_customers`
- `crm_opps`
- `crm_quotes`
- `crm_tasks`
- `crm_projects`
- `crm_prices`
- `crm_notifications`

## Kullanıcı modeli

Mevcut HTML içinde kullanıcılar sabit olarak tanımlı.

Alanlar:

- `key`
- `name`
- `title`
- `role`
- `hash`

Online yapıda:

- `auth.users` Supabase Auth tarafından tutulur
- uygulama profili için ayrıca `profiles` tablosu kullanılır

## Müşteri eşleşmesi

`crm_customers`

Alanlar:

- `id`
- `name`
- `city`
- `phone`
- `taxOffice`
- `taxNo`
- `status`
- `notes`
- bazı hızlı kayıtlarda `ownerKey`

Tablo: `customers`

## Fırsat eşleşmesi

`crm_opps`

Alanlar:

- `id`
- `name`
- `customerId`
- `customer`
- `ownerKey`
- `owner`
- `type`
- `source`
- `amount`
- `prob`
- `stage`
- `close`
- `competitor`
- `note`

Tablo: `opportunities`

Not:

- `customer` ve `owner` alanları türetilmiş alan gibi davranıyor.
- veritabanında ilişkisel yapı korunmalı, ad alanları raporlama performansı için snapshot olarak da tutulabilir.

## Teklif eşleşmesi

`crm_quotes`

Alanlar:

- `id`
- `no`
- `date`
- `status`
- `ownerKey`
- `owner`
- `customerId`
- `customer`
- `city`
- `phone`
- `tax`
- `oppId`
- `opportunity`
- `revision`
- `note`
- `paymentMethod`
- `items`
- `subtotal`
- `vat`
- `total`
- `cancelReason`

Tablolar:

- `quotes`
- `quote_items`

Not:

- `items` JSON olarak tutulabilir ama raporlama ve m3 hesapları için satır bazlı tablo daha doğru olur.

## Teklif kalemi eşleşmesi

Her teklif kalemi şu alanları içeriyor:

- `id`
- `type`
- `size`
- `thick`
- `qty`
- `base`
- `unit`
- `margin`
- `discount`
- `note`
- `total`

Tablo: `quote_items`

Ek öneri:

- `width_mm`
- `length_mm`
- `thickness_mm`
- `line_volume_m3`

Bu alanlar rapor performansı için ayrıca saklanabilir.

## Görev eşleşmesi

`crm_tasks`

Alanlar:

- `id`
- `title`
- `type`
- `priority`
- `status`
- `due`
- `ownerKey`
- `owner`
- `customerId`
- `customer`
- `quoteId`
- `desc`

Tablo: `tasks`

## Proje eşleşmesi

`crm_projects`

Alanlar:

- `id`
- `name`
- `customerId`
- `customer`
- `ownerKey`
- `owner`
- `status`
- `due`

Tablo: `projects`

## Fiyat listesi eşleşmesi

`crm_prices`

Bu kayıtlar ürün tipi başına m3 baz fiyatı tutuyor.

Tablo: `price_rules`

Alanlar:

- `product_type`
- `price_per_m3`

## Bildirim eşleşmesi

`crm_notifications`

Alanlar:

- `id`
- `text`
- `type`

Tablo: `notifications`

Ek öneri:

- `user_id`
- `is_read`
- `created_at`

## m3 hesap mantığı

Mevcut mantık:

- `kalınlık * en * boy * adet`
- mm ölçüler metreye çevrilerek hesaplanır

Örnek:

- 8 x 1250 x 2500 mm
- 0.008 x 1.25 x 2.5 = `0.025 m³`

Bu formül hem:

- teklif kalemlerinde
- raporlarda
- dashboard KPI'larında

aynı şekilde kullanılmalı.

## Rapor erişimi

Mevcut kurala göre rapor erişimi sadece:

- `omer`
- `kenan`

için açık.

Bu kural ilk MVP'de de korunmalı.

## İlk canlı geçiş stratejisi

1. Mevcut seed verileri JSON'a çıkarılır.
2. Supabase tablolarına import edilir.
3. `get()` ve `set()` mantığı repository fonksiyonlarına dönüştürülür.
4. Sayfa ilk yüklemede Supabase'den veri çeker.
5. Offline fallback istenirse daha sonra eklenir.

