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
   chmod +x ./install-ghost.sh

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

## Önemli yapılandırma (örnek env)
- SITE_URL: Blog adresi (ör. https://blog.example.com)  
- GHOST_PORT: 2368 (varsayılan)  
- GHOST_CONTENT: içerik dizini veya volume  
- DB_TYPE: sqlite veya mysql (gerekiyorsa DB bilgilerini verin)

Script, bu değişkenleri ortam değişkeni veya dosyadan alacak şekilde düzenlenmiş olabilir.

## Yönetim
- Log: podman logs -f ghost  
- Durdur: podman stop ghost  
- Başlat: podman start ghost  
- Sil: podman rm -f ghost

## Yedekleme & Güncelleme
- İçerik yedeği:
  podman cp ghost:/var/lib/ghost/content ./backup/content-YYYYMMDD
- Güncelleme:
  podman pull docker.io/library/ghost:latest
  podman rm -f ghost
  (aynı run komutunu yeniden çalıştırın)

## Kaldırma
- Container: podman rm -f <site-adı>

## Sorumluluk reddi
Bu script "olduğu gibi" sağlanır. Repo sahibi veya yazanlar script kullanımından doğan hiçbir zarardan sorumlu değildir. Çalıştırmadan önce içeriği inceleyin ve üretimde kullanmadan önce test edin.

## Katkı & İletişim
Hata veya öneri için: https://github.com/Padrosum/POGKS/issues  
Repo sahibi: Padrosum


Gemini AI kullanılmıştır.
