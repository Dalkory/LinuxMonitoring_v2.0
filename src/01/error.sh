#!/bin/bash

# Функция для проверки параметров
function check_parameters {

  # Проверка наличия только числовых значений для параметров number_subfolders и number_files
  if ! [[ $number_subfolders =~ ^[0-9]+$ ]] || ! [[ $number_files =~ ^[0-9]+$ ]]; then
    echo "Error: Parameters number of subfolders (${number_subfolders}) or number of files (${number_files}) must contain only numbers"
    exit 1
  fi

  # Проверка наличия только числового значения для параметра file_size и его ограничение до 100
  if ! [[ $file_size =~ ^[0-9]+$ ]] || [[ $[$file_size] -gt 100 ]]; then
    echo "Error: Parameter file size in kilobytes (${file_size_pre}) must contain numbers, (<100kb)"
    exit 1
  fi

  # Проверка наличия только буквенных значений для параметра folder_names и его ограничение до 7 символов
  if ! [[ $folder_names =~ ^[a-zA-Z]+$ ]] || [[ ${#folder_names} -gt 7 ]]; then
    echo "Error: Parameter ${folder_names} must contain letters, (<7)"
    exit 1
  fi
  
  # Проверка наличия только буквенных значений для параметра list_letters_start и его ограничение до 7 символов
  if ! [[ $list_letters_start =~ ^[a-zA-Z]+$ ]] || [[ ${#list_letters_start} -gt 7 ]]; then
    echo "Error: Parameter ${list_letters} (before the dot) must contain letters, (<7)"
    exit 1
  fi

  # Проверка наличия только буквенных значений для параметра list_letters_end и его ограничение до 3 символов
  if ! [[ $list_letters_end =~ ^[a-zA-Z]+$ ]] || [[ ${#list_letters_end} -gt 3 ]]; then
    echo "Error: Parameter ${list_letters} (after the dot) must contain letters, (<3)"
    exit 1
  fi
}

# Вызов функции для проверки параметров
check_parameters