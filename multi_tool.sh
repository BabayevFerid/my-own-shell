#!/bin/bash

# Menyu funksiyası
menu() {
    echo "-------------------------------------"
    echo " Sistem Multi-Tool Script"
    echo " 1) Sistem məlumatı göstər"
    echo " 2) Mövcud istifadəçilər"
    echo " 3) Disk istifadəsi"
    echo " 4) Fayl axtar"
    echo " 5) Proses axtar və öldür"
    echo " 6) Çıxış"
    echo "-------------------------------------"
    echo -n "Seçiminizi daxil edin [1-6]: "
}

system_info() {
    echo "=== Sistem Məlumatı ==="
    echo "Hostname: $(hostname)"
    echo "Kernel versiyası: $(uname -r)"
    echo "CPU: $(lscpu | grep 'Model name' | sed 's/Model name:\s*//')"
    echo "RAM: $(free -h | grep Mem | awk '{print $2}')"
    echo "Disk: $(df -h / | tail -1 | awk '{print $2 " istifadə olunub, " $4 " boşdur."}')"
    echo
}

list_users() {
    echo "=== Sistemdəki istifadəçilər ==="
    cut -d: -f1 /etc/passwd
    echo
}

disk_usage() {
    echo "=== Disk İstifadəsi ==="
    df -h
    echo
}

find_file() {
    echo -n "Axtarmaq istədiyiniz faylın adını yazın: "
    read filename
    echo "Fayllar tapılır..."
    find / -name "$filename" 2>/dev/null
    echo
}

process_kill() {
    echo -n "Axtarmaq istədiyiniz prosesin adını yazın: "
    read pname
    pids=$(pgrep "$pname")
    if [ -z "$pids" ]; then
        echo "Belə proses tapılmadı."
    else
        echo "Tapılan proseslər: $pids"
        echo -n "Bu prosesləri öldürmək istəyirsiniz? (y/n): "
        read answer
        if [[ $answer == "y" || $answer == "Y" ]]; then
            kill $pids
            echo "Proseslər öldürüldü."
        else
            echo "Heç bir proses öldürülmədi."
        fi
    fi
    echo
}

# Əsas döngü
while true; do
    menu
    read choice
    case $choice in
        1) system_info ;;
        2) list_users ;;
        3) disk_usage ;;
        4) find_file ;;
        5) process_kill ;;
        6) echo "Çıxış edilir..."; exit 0 ;;
        *) echo "Yanlış seçim! Yenidən cəhd edin." ;;
    esac
done
