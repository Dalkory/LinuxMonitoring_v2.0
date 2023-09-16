#!/bin/bash

# Основная функция
function main {
  param="$1"  # Первый аргумент командной строки - параметр
  chmod +x error.sh  # Устанавливаем исполняемое разрешение для скрипта error.sh
  source ./error.sh $param  # Запускаем скрипт error.sh с передачей параметра
  chmod +x clean_file_system.sh  # Устанавливаем исполняемое разрешение для скрипта clean_file_system.sh
  source ./clean_file_system.sh $param  # Запускаем скрипт clean_file_system.sh с передачей параметра
}

main "$@"  # Вызываем основную функцию с передачей всех аргументов командной строки