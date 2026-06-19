# Supabase Auth Sonraki Adım

Şu anda proje URL ve publishable key hazır.

Ancak veritabanındaki tablolar `authenticated` kullanıcı bekliyor. Bu yüzden uygulamanın canlı veriye gerçekten yazabilmesi için Supabase Auth içinde kullanıcı açılması gerekiyor.

## Senin yapacağın adım

1. Supabase projesini aç
2. Sol menüden `Authentication`
3. `Users`
4. `Add user`
5. Şimdilik en az şu iki kullanıcıyı oluştur:
   - Ömer Aslan
   - Kenan Kafdal

## Önerilen e-posta yapısı

İstersen geçici olarak şu şekilde aç:

- `omer@baunorm.local`
- `kenan@baunorm.local`
- `remzi@baunorm.local`
- `hakan@baunorm.local`
- `merve@baunorm.local`

## Şifre

Geçici ama güçlü bir şifre belirleyebilirsin.

Örnek format:

- en az 10 karakter
- harf + rakam + özel karakter

## Sonra bana ne göndereceksin

Kullanıcıları açtıktan sonra bana şunlardan birini yaz:

- `kullanıcılar açıldı`
- veya hangi e-posta adresleriyle açtığını

## Neden bu adım gerekli

Çünkü mevcut SQL politikaları sadece oturum açmış kullanıcıların:

- müşterileri
- fırsatları
- teklifleri
- görevleri
- projeleri

okumasına ve yazmasına izin veriyor.

Bu adım tamamlanınca ben:

1. uygulama giriş ekranını Supabase Auth'a bağlayacağım
2. kullanıcı profillerini canlı role bağlayacağım
3. localStorage yerine bulut veriyi çalıştıracağım
