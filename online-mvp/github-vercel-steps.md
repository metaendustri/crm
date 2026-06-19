# GitHub ve Vercel Son Adımlar

## 1. GitHub repo oluştur

GitHub'da:

1. `New repository`
2. Repo adı: `baunorm-crm`
3. Public veya Private seç
4. `Create repository`

## 2. Terminal komutları

Terminal açıp şunları sırayla çalıştır:

```bash
cd "/Users/omeraslan/Desktop/Nerdeydi"
git init
git add .
git commit -m "Initial BAUNORM CRM deploy package"
git branch -M main
git remote add origin REPO_URL
git push -u origin main
```

`REPO_URL` örnek:

```bash
https://github.com/KULLANICI_ADI/baunorm-crm.git
```

## 3. Vercel import

1. Vercel'e gir
2. `Add New...`
3. `Project`
4. GitHub repo'yu seç
5. `Deploy`

## 4. Beklenen yayın davranışı

Vercel bu projeyi statik site olarak yayınlayacak ve `index.html` ana giriş olacak.

## 5. Sonraki teknik adım

Deploy sonrası birlikte:

- canlı domain linkini kontrol ederiz
- Supabase bağlantısını production ortamında test ederiz
- gerekirse özel domain bağlarız
