#!/bin/bash

if [ $# != 0 ] ; then
    echo "Error: Не принимаются аргументы командной строки" # Выводим ошибку, если переданы аргументы командной строки
    exit 1
fi

sudo apt install nginx-light  # Устанавливаем пакет nginx-light
sudo cp ./nginx.conf /etc/nginx/nginx.conf  # Копируем файл конфигурации nginx в соответствующее место
sudo nginx -s reload  # Перезапускаем nginx для применения изменений
sudo cp prometheus.yml /etc/prometheus/prometheus.yml  # Копируем файл конфигурации Prometheus в соответствующее место
systemctl restart prometheus.service  # Перезапускаем службу Prometheus

install_nginx() {
    if ! [[ -n $(dpkg -l | grep nginx) ]]; then  # Проверяем, установлен ли пакет nginx
        sudo apt install nginx-light  # Устанавливаем пакет nginx-light
        sudo cp ./nginx/nginx.conf /etc/nginx/nginx.conf  # Копируем файл конфигурации nginx в соответствующее место
        sudo nginx -s reload  # Перезапускаем nginx для применения изменений
    fi
}

get_info() {
    cpu=`top -b | head -3 | tail +3 | awk '{print $2}'`  # Получаем информацию о загрузке ЦПУ
    mem_free=`top -b | head -4 | tail +4 | awk '{print $6}'`  # Получаем информацию о свободной памяти
    mem_used=`top -b | head -4 | tail +4 | awk '{print $8}'`  # Получаем информацию о используемой памяти
    mem_cache=`top -b | head -4 | tail +4 | awk '{print $10}'`  # Получаем информацию о кэшированной памяти
    disk_used=`df / | tail -n1 | awk '{print $3}'`  # Получаем информацию о занятом дисковом пространстве
    disk_available=`df / | tail -n1 | awk '{print $4}'`  # Получаем информацию о доступном дисковом пространстве
    
    echo \# HELP s21_cpu_usage Использование ЦПУ.
    echo \# TYPE s21_cpu_usage gauge
    echo s21_cpu_usage $cpu  # Выводим информацию об использовании ЦПУ
    echo \# HELP s21_mem_free Свободная память.
    echo \# TYPE s21_mem_free gauge
    echo s21_mem_free $mem_free  # Выводим информацию о свободной памяти
    echo \# HELP s21_mem_used Используемая память.
    echo \# TYPE s21_mem_used gauge
    echo s21_mem_used $mem_used  # Выводим информацию об используемой памяти
    echo \# HELP s21_mem_cache Кэшированная память.
    echo \# TYPE s21_mem_cache gauge
    echo s21_mem_cache $mem_cache  # Выводим информацию о кэшированной памяти
    echo \# HELP s21_disk_used Занятое дисковое пространство.
    echo \# TYPE s21_disk_used gauge
    echo s21_disk_used $disk_used  # Выводим информацию о занятом дисковом пространстве
    echo \# HELP s21_disk_available Доступное дисковое пространство.
    echo \# TYPE s21_disk_available gauge
    echo s21_disk_available $disk_available  # Выводим информацию о доступном дисковом пространстве
}

generate_prometheus_page() {
    get_info
}

main_node_exporter() {
    install_nginx  # Устанавливаем nginx, если он еще не установлен
    sudo cp prometheus.yml /etc/prometheus/prometheus.yml  # Копирурываем файл конфигурации Prometheus в соответствующее место
    systemctl restart prometheus.service  # Перезапускаем службу Prometheus
    
    while true; do
        generate_prometheus_page > ./index.html  # Генерируем страницу Prometheus и сохраняем ее в файл index.html
        sleep 3  # Ждем 3 секунды
    done;
}

main_node_exporter  # Вызываем функцию main_node_exporter для запуска скрипта