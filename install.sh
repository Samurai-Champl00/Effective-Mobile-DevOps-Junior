#!/bin/bash

set -e



echo "Установка"

# Копируем основной скрипт
cp monitor.sh /usr/local/bin/monitor_test.sh
chmod +x /usr/local/bin/monitor_test.sh

# Создаем логи
touch /var/log/monitoring.log
chmod 644 /var/log/monitoring.log


#Конфиг systemd
cp monitor-test.service /etc/systemd/system/
cp monitor-test.timer /etc/systemd/system/

# Ребут демона и таймер
systemctl daemon-reload
systemctl enable monitor-test.timer
systemctl restart monitor-test.timer

if systemctl is-active --quiet monitor-test.timer; then
    echo "Таймер запущен"
    echo "Логи событий: /var/log/monitoring.log"
else
    echo "Таймер не запустился"
    exit 1
fi