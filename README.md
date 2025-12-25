# POGKS — Podman Ghost Kurulum Scripti

Basit ve hızlı: Bu repo, Podman kullanarak Ghost blog'unu container içinde çalıştırmak için bir kurulum scripti içerir.

## Gereksinimler
- Podman
- Bash Shell
- İnternet bağlantısı
- Yeterli disk alanı

## kurulum
1. Repoyu indirme
git clone https://github.com/Padrosum/POGKS

2. cd POGKS
  
3. Script'e çalıştırma izni verin:
   chmod +x ./*.sh

4. Çalıştırın:
   ./*.sh

   ya da

   bash *.sh

El ile örnek:
```bash
podman volume create ghost-content
podman run -d --name ghost \
  -p 2368:2368 \
  -v ghost-content:/var/lib/ghost/content \
  -e url="http://blog.example.com" \
  docker.io/library/ghost:latest
```

## Yönetim
- Log: podman logs <site-adı>  
- Durdur: podman stop <site-adı>  
- Başlat: podman start <site-adı>  
- Sil: podman rm -f <site-adı>

## Kaldırma
- Container: podman rm -f <site-adı>

## Sorumluluk reddi
Bu script "olduğu gibi" sağlanır. Repo sahibi veya yazanlar script kullanımından doğan hiçbir zarardan sorumlu değildir. Çalıştırmadan önce içeriği inceleyin ve üretimde kullanmadan önce test edin.

## Katkı & İletişim
Hata veya öneri için: https://github.com/Padrosum/POGKS/issues  
Repo sahibi: Padrosum


Gemini AI kullanılmıştır.
