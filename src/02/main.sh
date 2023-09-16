#!/bin/bash

# Основная функция
function main {
  param=$#  # Получаем количество параметров, переданных в скрипт
  folder_names="$1"  # Получаем первый параметр - имена папок
  letters_file_name_ext="$2"  # Получаем второй параметр - имя файла с буквами
  file_size_pre="$3"  # Получаем третий параметр - предварительный размер файла
  file_size=${file_size_pre%%[!0-9]*}  # Извлекаем числовое значение из предварительного размера файла
  chmod +x error.sh  # Устанавливаем права на выполнение для скрипта error.sh
  source ./error.sh $folder_names $letters_file_name_ext $file_size  # Запускаем скрипт error.sh с передачей параметров
  chmod +x trashing_file_system.sh  # Устанавливаем права на выполнение для скрипта trashing_file_system.sh
  source ./trashing_file_system.sh $folder_names $letters_file_name_ext $file_size  # Запускаем скрипт trashing_file_system.sh с передачей параметров
}

main "$@"  # Вызываем основную функцию с передачей всех переданных параметров в скрипт