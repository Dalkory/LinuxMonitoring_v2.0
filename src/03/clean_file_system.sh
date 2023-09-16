#!/bin/bash

# Функция для удаления файлов и папок на основе лог-файла
function by_log_file() {
  # Путь к лог-файлу с записями об удаляемых файлах или папках
  log_file="../02/log_file.txt"

  if [ ! -f "$log_file" ]; then
    echo "Error: Log file not found!"  # Выводим сообщение об ошибке, если лог-файл не найден
    return 1  # Возвращаем код ошибки 1
  fi

  mapfile -t lines < "$log_file"  # Читаем строки из лог-файла в массив

  for line in "${lines[@]}"; do  # Перебираем строки лог-файла
    file_or_folder=$(echo "$line" | awk '{print $5}')  # Извлекаем имя файла или папки из строки
    if [ -e "$file_or_folder" ]; then  # Проверяем существование файла или папки
      sudo rm -rf "$file_or_folder" &> /dev/null  # Удаляем файл или папку с использованием sudo (если требуется)
      echo "$file_or_folder is deleted"  # Выводим сообщение об удалении файла или папки
    else
      echo "$file_or_folder not found"  # Выводим сообщение, если файл или папка не найдены
    fi
  done
}

# Функция для удаления файлов и папок на основе даты и времени создания
function by_creation_date_and_time() {
  read -p "Enter start time (Format: YYYY-mm-dd HH:MM): " start_time  # Запрашиваем у пользователя время начала
  read -p "Enter finish time (Format: YYYY-mm-dd HH:MM): " finish_time  # Запрашиваем у пользователя время окончания
  check_datetime_format "$start_time" || { echo "Error: Invalid start time format!"; return 1; }  # Проверяем формат времени начала
  check_datetime_format "$finish_time" || { echo "Error: Invalid finish time format!"; return 1; }  # Проверяем формат времени окончания
  find / -newerct "$start_time" ! -newerct "$finish_time" -exec sudo rm -rf {} \; 2>/dev/null  # Ищем и удаляем файлы и папки, созданные в указанном временном диапазоне
  echo "Deletion complete."  # Выводим сообщение о завершении удаления
}

# Функция для проверки формата даты и времени
function check_datetime_format() {
  local datetime="$1"
  if [[ ! $datetime =~ ^[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])\ (0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$ ]]; then  # Проверяем, соответствует ли формат даты и времени указанному шаблону YYYY-mm-dd HH:MM
    return 1  # Возвращаем код ошибки 1, если формат некорректный
  fi
  return 0  # Возвращаем успешный код, если формат корректный
}

# Функция для удаления файлов и папок на основе маски имени
function by_name_mask() {
  read -p "Enter the name mask to delete (e.g., *.txt, file*, folder*, etc.): " name_mask  # Запрашиваем у пользователя маску имени для удаления
  if [ -z "$name_mask" ]; then  # Проверяем, не пустая ли маска имени
    echo "Error: Name mask cannot be empty!"  # Выводим сообщение об ошибке, если маска имени пустая
    return 1  # Возвращаем код ошибки 1
  fi
  find / -name "$name_mask" -exec rm -rf {} \; 2>/dev/null  # Ищем и удаляем файлыи папки, соответствующие маске имени
  echo "Deletion complete."  # Выводим сообщение о завершении удаления
}

if [[ $param -eq 1 ]]; then  # Если параметр равен 1
  by_log_file  # Вызываем функцию для удаления файлов и папок на основе лог-файла
elif [[ $param -eq 2 ]]; then  # Если параметр равен 2
  by_creation_date_and_time  # Вызываем функцию для удаления файлов и папок на основе даты и времени создания
elif [[ $param -eq 3 ]]; then  # Если параметр равен 3
  by_name_mask  # Вызываем функцию для удаления файлов и папок на основе маски имени
else
  echo "Something went wrong, please try again later"  # Выводим сообщение об ошибке, если параметр некорректный
fi