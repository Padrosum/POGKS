#!/bin/bash

# --- RENK TANIMLAMALARI ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- YARDIMCI FONKSİYONLAR ---
function print_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ____   ___   ____ _  ______ "
    echo " |  _ \ / _ \ / ___| |/ / ___|"
    echo " | |_) | | | | |  _| ' /\___ \\"
    echo " |  __/| |_| | |_| | . \ ___) |"
    echo " |_|    \___/ \____|_|\_\____/ "
    echo "                               "
    echo -e "      >> POGKS v2 - Domain Destekli Kurulum <<${NC}"
    echo -e "${BLUE}----------------------------------------------------------${NC}"
}

function print_info() { echo -e "${BLUE}[BİLGİ]${NC} $1"; }
function print_success() { echo -e "${GREEN}[BAŞARILI]${NC} $1"; }
function print_warn() { echo -e "${YELLOW}[UYARI]${NC} $1"; }
function print_error() { echo -e "${RED}[HATA]${NC} $1"; }

# --- ANA PROGRAM ---
print_banner

# 1. Podman Kontrolü
if ! command -v podman &> /dev/null; then
    print_error "Podman sistemde yüklü değil!"
    exit 1
fi

echo -e "${BOLD}Lütfen aşağıdaki bilgileri doldurun:${NC}"

# 2. Kullanıcı Girdileri

# PORT SORUSU
while true; do
    read -p "$(echo -e ${CYAN}"?? Yerel Port (Localhost'ta çalışacak port) (Örn: 3000): "${NC})" CUSTOM_PORT
    if [[ "$CUSTOM_PORT" =~ ^[0-9]+$ ]]; then break; else print_error "Sadece sayı giriniz."; fi
done

# DOMAIN SORUSU (YENİ ÖZELLİK)
echo ""
print_info "Eğer Cloudflare Tunnel veya Domain kullanıyorsanız tam adresi yazın."
print_info "Sadece deneme yapıyorsanız boş bırakıp ENTER'a basın (Localhost ayarlanır)."
read -p "$(echo -e ${CYAN}"?? Site Adresi (Örn: https://blog.benimsite.com): "${NC})" SITE_URL

# Eğer boş bırakılırsa localhost varsayılan olsun
if [ -z "$SITE_URL" ]; then
    SITE_URL="http://localhost:$CUSTOM_PORT"
    print_warn "Adres girilmedi, $SITE_URL olarak ayarlanıyor."
else
    # Sonunda / işareti varsa kaldıralım (Ghost sevmez)
    SITE_URL=${SITE_URL%/}
    print_success "Site adresi ayarlandı: $SITE_URL"
fi
echo ""

# İSİM SORUSU
read -p "$(echo -e ${CYAN}"?? Konteyner adı ne olsun? (Varsayılan: my-ghost): "${NC})" CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-my-ghost}
VOLUME_NAME="${CONTAINER_NAME}_data"

# 3. Çakışma Kontrolü
if podman ps -a --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
    print_warn "'$CONTAINER_NAME' zaten var."
    read -p "$(echo -e ${RED}"!! Silip tekrar kurulsun mu? (Verileriniz korunur) (e/h): "${NC})" SECIM
    if [[ "$SECIM" == "e" || "$SECIM" == "E" ]]; then
        podman rm -f $CONTAINER_NAME > /dev/null
        print_success "Eski konteyner silindi."
    else
        exit 0
    fi
fi

# 4. Kurulum İşlemi
echo ""
print_info "Ghost başlatılıyor..."
print_info "Ayarlanan URL: $SITE_URL"

if podman run -d \
  --name "$CONTAINER_NAME" \
  -p "$CUSTOM_PORT:2368" \
  -v "$VOLUME_NAME:/var/lib/ghost/content:Z" \
  -e url="$SITE_URL" \
  -e database__client=sqlite3 \
  -e database__connection__filename="/var/lib/ghost/content/data/ghost.db" \
  docker.io/library/ghost:latest; then
    
    echo ""
    print_banner
    print_success "GÜNCELLEME TAMAMLANDI!"
    echo ""
    echo -e "   Site Adresi   : ${CYAN}$SITE_URL${NC}"
    echo -e "   Yerel Erişim  : ${CYAN}http://localhost:$CUSTOM_PORT${NC}"
    echo ""
    print_info "Ghost'un yeni adresi algılaması 10-20 saniye sürebilir."
    echo ""
else
    echo ""
    print_error "Kurulum başarısız oldu!"
    exit 1
fi
