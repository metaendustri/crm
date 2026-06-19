# BAUNORM CRM Canlıya Alma Planı

Bu belge, uygulamayı birlikte canlıya almak için adım adım yol haritasıdır.

## Hızlı özet

Senin tarafta:

1. Supabase hesabı açılacak
2. Yeni proje oluşturulacak
3. Veritabanı şeması çalıştırılacak
4. Kullanıcı hesapları açılacak
5. Proje anahtarları benimle paylaşılacak
6. Hosting hesabı açılacak

Benim tarafta:

1. HTML uygulamayı Supabase'e bağlayacağım
2. localStorage yerine canlı veri okuma/yazma ekleyeceğim
3. giriş akışını canlı hale getireceğim
4. seed veriyi import etmeye hazırlayacağım
5. yayına hazır dosya yapısını düzenleyeceğim

## 1. Senin yapacağın ilk adımlar

### 1. Supabase hesabı aç

- [https://supabase.com](https://supabase.com) adresine gir
- hesap oluştur
- giriş yap

### 2. Yeni proje oluştur

Proje oluştururken:

- Project name: `baunorm-crm`
- Database password: güçlü bir şifre belirle
- Region: Türkiye'ye yakın bir bölge seç

Not:

- Veritabanı şifresini sakla
- Bu şifreyi bana yazmana gerek yok

### 3. SQL Editor'u aç

Supabase içinde:

- sol menüden `SQL Editor`
- `New query`

Sonra şu dosyanın içeriğini çalıştır:

- [supabase-schema.sql](/Users/omeraslan/Desktop/Nerdeydi/online-mvp/supabase-schema.sql)

### 4. Authentication ayarını aç

Supabase içinde:

- `Authentication`
- `Providers`
- Email provider açık olsun

İlk aşamada sadece e-posta/şifre yeterli.

### 5. Gerekli bilgileri bana gönder

Supabase içinde:

- `Project Settings`
- `API`

Bana şunları ilet:

- `Project URL`
- `anon public key`

Bunlarla ben HTML tarafını canlı bağlayabilirim.

## 2. Kullanıcı hesapları

İlk aşamada şu kullanıcıları açacağız:

- Ömer Aslan
- Kenan Kafdal
- Remzi Hamdi Özkan
- Hakan Arıcı
- Merve Tanka

İki seçenek var:

1. En hızlı yöntem:
   Supabase Auth içinde bu kullanıcıları manuel oluşturursun.

2. Daha temiz yöntem:
   Ben sana tek seferde çalıştırılacak insert script'i hazırlayayım.

Önerim:

- önce ben script hazırlayayım
- sen sadece çalıştır

## 3. Hosting için senin yapacağın adımlar

En hızlı seçenek `Vercel`.

### Vercel adımları

1. [https://vercel.com](https://vercel.com) hesabı aç
2. GitHub hesabın varsa bağla
3. İstersen projeyi GitHub'a koyalım, istersen düz statik deploy da yapabiliriz

Hızlı MVP için iki yol var:

1. Statik dosya yayını
   Sadece HTML dosyasını yayına veririz

2. Repo tabanlı yayın
   Daha düzenli ve sürdürülebilir olur

Önerim:

- repo tabanlı yayın

## 4. Benden sonra gelecek teknik işler

Ben sırayla şunları yapacağım:

1. `BAUNORM CRM.html` içine Supabase client ekleyeceğim
2. sabit kullanıcı listesini canlı profil verisine bağlayacağım
3. müşteri, fırsat, teklif, görev ve proje CRUD işlemlerini Supabase'e yazacağım
4. rapor ekranını veritabanı verisiyle besleyeceğim
5. offline fallback gerekiyorsa ikinci katman olarak bırakacağım

## 5. Beraber ilerleme sırası

Sıra şu şekilde en verimli olur:

1. Sen Supabase projesini aç
2. Bana `Project URL` ve `anon public key` gönder
3. Ben uygulamayı canlı veriye bağlayayım
4. Sonra kullanıcı seed script'ini hazırlayayım
5. Sonra hostinge çıkalım

## 6. Şu an senden beklediğim

Şimdilik bana şu ikisini gönder:

- `Supabase Project URL`
- `Supabase anon public key`

İstersen bir ekran görüntüsü olarak da atabilirsin.
