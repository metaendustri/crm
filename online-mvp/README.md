# BAUNORM CRM Online MVP

Bu klasör, mevcut tek dosyalı `BAUNORM CRM.html` uygulamasını hızlıca online çalışan bir MVP'ye dönüştürmek için gerekli omurgayı içerir.

## Hedef

İlk aşamada mevcut arayüz korunur. `localStorage` ile çalışan veri yapısı, Supabase tabanlı kalıcı veriye taşınır.

## Önerilen hızlı kurulum

1. Mevcut arayüz dosyası korunur.
2. Veritabanı olarak Supabase kullanılır.
3. Kimlik doğrulama Supabase Auth ile yapılır.
4. Hosting için Vercel veya Netlify kullanılır.
5. PDF üretimi ilk aşamada tarayıcı tabanlı kalabilir.

## MVP kapsamı

- Kullanıcı girişi
- Müşteriler
- Satış fırsatları
- Teklifler
- Teklif kalemleri
- Görevler
- Projeler
- Bildirimler
- m3 bazlı raporlama

## Neden bu yapı

- Mevcut ekranı yeniden yazmadan online'a alınabilir.
- Veriler kalıcı olur.
- Çok kullanıcılı kullanım açılır.
- Daha sonra mobil uygulama veya panel ayrıştırması kolaylaşır.

## Dosyalar

- `supabase-schema.sql`
  Veritabanı tabloları, enum'lar, view'lar ve temel RLS politikaları.

- `migration-notes.md`
  Mevcut `localStorage` alanlarının veritabanına nasıl eşleneceği.

## Önerilen aşamalar

1. Supabase projesi açılır.
2. `supabase-schema.sql` çalıştırılır.
3. Kullanıcılar oluşturulur:
   - Ömer Aslan
   - Kenan Kafdal
   - Remzi Hamdi Özkan
   - Hakan Arıcı
   - Merve Tanka
4. Mevcut seed verileri veritabanına aktarılır.
5. HTML içindeki `get/set` katmanı Supabase adapter ile değiştirilir.
6. Son aşamada offline fallback bırakılabilir.

## En hızlı teknik yaklaşım

İlk canlı sürüm için React veya tam backend zorunlu değil. Şu akış yeterli:

- `BAUNORM CRM.html`
- `supabase-js` CDN
- giriş sonrası kullanıcıya göre veri çekme
- CRUD işlemlerini doğrudan Supabase tablolarına yazma

Bu yaklaşım hızlı MVP için uygundur. Sonraki aşamada uygulama:

- modüllere ayrılabilir
- Next.js veya başka bir yapıya taşınabilir
- sunucu tarafı PDF üretimi eklenebilir

