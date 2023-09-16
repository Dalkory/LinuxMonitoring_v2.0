#!/bin/bash

function main {

  absolute_path="$1" # Абсолютный путь к основной папке
  number_subfolders="$2" # Количество подпапок для создания
  folder_names="$3" # Шаблон имени папок
  number_files="$4" # Количество файлов для создания в каждой папке
  list_letters="$5" # Шаблон имени файлов (с расширением)
  list_letters_start=${list_letters%.*} # Начало имени файлов (без расширения)
  list_letters_end=${list_letters#*.} # Расширение файлов
  file_size_pre="$6" # Размер файлов (с указанием единиц измерения)
  file_size=${file_size_pre%kb} # Размер файлов в Кб

  # Проверка количества введенных параметров
  if [ $# != 6 ]; then
    echo "Error: $param parameters! Input 6 parameters: (example: /opt/test 4 az 5 az.az 3kb)"
    exit 1
  else
    chmod +x error.sh # Установка прав на выполнение скрипта error.sh
      source ./error.sh $number_subfolders  $folder_names $number_files $list_letters \
      $list_letters_start $list_letters_end $file_size_pre $file_size # Запуск скрипта error.sh с передачей параметров
    chmod +x file_generator.sh # Установка прав на выполнение скрипта file_generator.sh
      source ./file_generator.sh $absolute_path $number_subfolders $folder_names \
      $number_files $list_letters_start $list_letters_end $file_size # Запуск скрипта file_generator.sh с передачей параметров
  fi 
}

main "$@"  # Вызываем основную функцию с передачей всех аргументов командной строки