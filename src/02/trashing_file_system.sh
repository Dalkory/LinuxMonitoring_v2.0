#!/bin/bash

MIN=1
MAX=100

start_trashing_time=$(date +%s.%3N) # Записываем текущее время в переменную start_trashing_time с миллисекундным разрешением
folder_names="$1" # Получаем первый аргумент командной строки и сохраняем его в переменную folder_names
file_name="$2" # Получаем второй аргумент командной строки и сохраняем его в переменную file_name
only_file_name=${file_name%.*} # Извлекаем только имя файла из переменной file_name
list_ext=${file_name#*.} # Извлекаем расширение файла из переменной file_name
file_size="$3" # Получаем третий аргумент командной строки и сохраняем его в переменную file_size
folder_names_end=${folder_names: -1} # Извлекаем последний символ из переменной folder_names
file_name_end=${only_file_name: -1} # Извлекаем последний символ из переменной only_file_name
folder_names_length=${#folder_names} # Вычисляем длину строки переменной folder_names
file_name_length=${#only_file_name} # Вычисляем длину строки переменной only_file_name
enough=$(date +%d%m%y) # Получаем текущую дату и сохраняем ее в переменную enough

function name_creator() {
  name=""
  length_min=4
  idx_1=$1
  idx_2=$2
  file_name_last=$4
  some_letters=$3
  random_lenght=$(( $RANDOM % $length_min + 4 )) # Генерируем случайное число от 4 до 7 и сохраняем его в переменную random_lenght
  declare -a letters
  for ((f=0; f<$(( $idx_2 + 1 )); f++)); do
    letters[$jj]="${some_letters:$jj:1}"
    jj=$(( $jj + 1 ))
  done
  if [[ $random_lenght -gt $idx_2 ]]; then # Если случайная длина больше idx_2
    for ((a=o; a<$(( $idx_1 )); a++)); do
      name="$file_name_last$name";
    done
    for (( k=$idx_2; k>=0; k-- )); do
      ii=$(( $k - 1 ))
      name="${letters[$ii]}$name"
    done
  elif [[ $idx -eq 1 ]]; then
    name="$folder_names"
  fi
  echo "$name"
}

function check_free_memory() {
  local avialable=$(df --output=avail / | tail -1) # Получаем доступное место на диске корневой файловой системы (/) и сохраняем его в переменную available
  if [[ $avialable -lt 1048576 ]]; then # Если доступное место меньше 1 ГБ
    echo "Available space: less than 1 GB of free space." >> log_file.txt # Выводим сообщение об ошибке в файл log_file.txt
    stop_trashing # Вызываем функцию stop_trashing для завершения скрипта
    exit 1
  fi
}

function creator_subfolders_with_files() {
  list=$(compgen -d / | grep -v 'bin\|sbin\|proc\|sys\|root') # Получаем список всех подпапок в корневой файловой системе (/), исключая некоторые системные папки, и сохраняем его в переменную list
  echo "$list" > path.txt # Записываем список подпапок в файл path.txt
  subfolder_name=""
  new_file_name=""
  number_subfolders=$(( $RANDOM % ($MAX - $MIN + 1) + $MIN )) # Генерируем случайное число подпапок от MIN до MAX и сохраняем его в переменную number_subfolders
  for ((i=0; i<$number_subfolders; i++)); do # Цикл для создания указанного количества подпапок
    check_free_memory
    path=$(shuf -n 1 path.txt) # Выбираем случайную папку из списка в файле path.txt и сохраняем ее в переменную path
    tmp_foldname="$(name_creator $i $folder_names_length $folder_names $folder_names_end)" # Генеррим имя для подпапки с помощью функции name_creator и сохраняем его в переменную tmp_foldname
    subfolder_name="${tmp_foldname}_${enough}" # Добавляем текущую дату к имени подпапки и сохраняем его в переменную subfolder_name
    local subfolder_path="${path}/${subfolder_name}" # Формируем путь к новой подпапке
    sudo mkdir -p "$subfolder_path" &>/dev/null # Создаем подпапку с помощью команды mkdir с параметром -p, чтобы создать все родительские папки, если их нет. Ошибки выводятся в /dev/null
    if ! [[ -e $subfolder_path ]]; then # Если подпапка не создана
      echo "$subfolder_path not created" >> error_1.txt # Записываем сообщение об ошибке в файл error_1.txt
    else
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) created folder $subfolder_path" >> log_file.txt # Записываем сообщение о создании подпапки в файл log_file.txt
      number_files=$(( $RANDOM % $MAX + $MIN )) # Генерируем случайное число файлов от MIN до MAX и сохраняем его в переменную number_files
      echo "rund_number_files=$number_files"
      for ((b=0; b<$number_files; b++)); do # Цикл для создания указанного количества файлов
        check_free_memory
        tmp_filename="$(name_creator $b $file_name_length $only_file_name $file_name_end)_${enough}" # Генерируем имя файла с помощью функции name_creator и добавляем текущую дату к имени файла
        new_file_name="${tmp_filename}.${list_ext}" # Формируем имя файла с расширением из переменных tmp_filename и list_ext
        local file_path="${path}/${subfolder_name}/${new_file_name}" # Формируем путь к новому файлу
        sudo dd if=/dev/zero of="${file_path}" bs=1M count="$file_size" &>/dev/null # Создаем файл с помощью команды dd, который заполняет его нулевыми байтами. Размер файла задается с помощью параметров bs (размер блока) и count (количество блоков). Ошибки выводятся в /dev/null
        if [[ -e $file_path ]]; then # Если файл создан
          echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) created file ${path}/${subfolder_name}/${new_file_name} ${file_size}Kb" >> log_file.txt # Записываем сообщение о создании файла в файл log_file.txt
        else
          echo "$file_path not created" >> error_2.txt # Записываем сообщение об ошибке в файл error_2.txt
        fi
      done
    fi
  done
}

function stop_trashing () {
  finish_trashing_time=$(date +%s.%3N) # Записываем текущее время в переменную finish_trashing_time с миллисекундным разрешением
  finish_time=$(date +'%Y-%m-%d %H:%M:%S') # Записываем текущую дату и время в переменную finish_time
  echo "$finish_time finish script time" >> log_file.txt # Записываем время окончания скрипта в файл log_file.txt
  echo "Script is finished at $finish_time"
  lead_time=$(bc<<<"scale=4;$finish_trashing_time - $start_trashing_time") # Вычисляем время выполнения скрипта и сохраняем его в переменную lead_time
  echo "Script execution time (in sec) = $lead_time"
  echo "$lead_time Script execution time (in sec)" >> log_file.txt # Записываем время выполнения скрипта в файл log_file.txt
  rm -rf error.txt # Удаляем файл error.txt
  rm -rf error_1.txt # Удаляем файл error_1.txt
  rm -rf error_2.txt # Удаляем файл error_2.
}

function create_log_file() {
  touch log_file.txt  # Создаем файл log_file.txt
  start_time=$(date +'%Y-%m-%d %H:%M:%S')  # Записываем текущую дату и время в переменную start_time
  echo "$start_time Start script time" >> log_file.txt  # Записываем время начала скрипта в файл log_file.txt
  echo "Script is started at $start_time"  # Выводим сообщение о начале скрипта с указанием времени
  creator_subfolders_with_files  # Вызываем функцию creator_subfolders_with_files
  stop_trashing  # Вызываем функцию 
  rm -rf path.txt # Удаляем файл path.
}

create_log_file  # Вызываем функцию create_log_file
