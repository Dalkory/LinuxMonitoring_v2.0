#!/bin/bash

function main {
  bash ../04 main.sh
  param="$1"  # Присваиваем значение первого аргумента функции переменной param
  chmod +x error.sh  # Даем права на выполнение скрипта error.sh
  source ./error.sh $param  # Запускаем скрипт error.sh с передачей параметра $param
  chmod +x monitoring.sh  # Даем права на выполнение скрипта monitoring.sh
  source ./monitoring.sh $param  # Запускаем скрипт monitoring.sh с передачей параметра $param
}

main "$@" # Вызываем основную функцию с передачей всех аргументов командной строки