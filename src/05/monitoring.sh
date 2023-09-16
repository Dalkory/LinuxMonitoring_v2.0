#!/bin/bash

function sort_response_code() {
  touch response_code.log  # Создаем файл response_code.log
  touch tmp.log  # Создаем временный файл tmp.log
  for i in {1..5}; do  # Цикл от 1 до 5
    awk '{print $9, $0}' ../04/access${i}.log >> tmp.log  # Извлекаем колонки 9 и 0 из файла access_log_${i}.log и сохраняем в tmp.log
    echo "access$i.log отсортирован"
  done
  sort -n tmp.log > response_code.log  # Сортируем содержимое tmp.log по числовому значению и сохраняем в response_code.log
  awk '{print substr($0, 5)}' response_code.log > tmp_2.log  && mv tmp_2.log  response_code.log  # Удаляем первые 4 символа из каждой строки response_code.log и сохраняем в response_code.log
  rm -f tmp.log  # Удаляем временный файл tmp.log
}

function sort_unique_IP() {
  touch unique_ips.log  # Создаем файл unique_ips.log
  for i in {1..5}; do  # Цикл от 1 до 5
    awk '{print $1}' ../04/access$i.log | sort -u > unique_ips.log  # Извлекаем колонку 1 из файла access_log_$i.log, сортируем уникальные значения и сохраняем в unique_ips.log
    echo "access$i.log отсортирован"
  done
}

function sort_requests_with_errors() {
  touch requests_with_err.log  # Создаем файл requests_with_err.log
  for i in {1..5}; do  # Цикл от 1 до 5
    awk '$9 ~ /^[45][0-9][0-9]$/ {print $0}' ../04/access$i.log > requests_with_err.log  # Извлекаем строки, где колонка 9 соответствует шаблону 4xx или 5xx, и сохраняем в requests_with_err.log
    echo "access$i.log отсортирован"
  done
}

function sort_unique_IP_in_erroneous_requests() {
  touch unique_IP_err.log  # Создаем файл unique_IP_err.log
  for i in {1..5}; do  # Цикл от 1 до 5
    awk '$9 ~ /^[45][0-9][0-9]$/ { print $1 }' ../04/access$i.log | sort -u >> unique_IP_err.log  # Извлекаем колонку 1, где колонка 9 соответствует шаблону 4xx или 5xx, сортируем уникальные значения и добавляем в unique_IP_err.log
    echo "access$i.log отсортирован"
  done
}

function monitoring {
  case $param in
    1) sort_response_code
    ;;  # Завершение оператора case
    2) sort_unique_IP 
    ;;  # Завершение оператора case
    3) sort_requests_with_errors  
    ;;  # Завершение оператора case
    4) sort_unique_IP_in_erroneous_requests
    ;;  # Завершение оператора case
    *) echo "Что-то пошло не так, пожалуйста, повторите попытку позже"
       exit 1
    ;;  # Завершение оператора case в случае неправильного значения параметра
  esac
}

monitoring