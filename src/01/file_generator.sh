#!/bin/bash

absolute_path="$1" # Абсолютный путь к основной папке
number_subfolders="$2" # Количество подпапок для создания
folder_names="$3" # Шаблон имени папок
number_files="$4" # Количество файлов для создания в каждой папке
list_letters_start="$5" # Шаблон начала имени файлов
list_letters_end="$6" # Расширение файлов
file_size="$7" # Размер файлов в Кб
last_fol_sym=${folder_names: -1} # Последний символ в имени папки
last_file_sym=${list_letters_start: -1} # Последний символ в имени файла
length_fol=${#folder_names} # Длина имени папки (количество символов)
length_file=${#list_letters_start} # Длина имени файла (количество символов)
suff=$(date +%d%m%y) # Дополнение к имени папок и файлов (текущая дата)

function name_generator() {
  name=""
  length_min=4 # Минимальная длина имени
  idx1=$1 # Индекс для номера папки/файла (сколько папок/файлов нужно создать)
  idx2=$2 # Количество букв в шаблоне
  last=$4 # Последний символ в имени
  some_letters=$3 # Доступные символы для имени
  random_lenght=$[ $RANDOM % $length_min + 4 ] # Случайное число для генерации длины имени

  declare -a letters # Создание массива для символов имени
  for ((f=0; f<$(( $idx2 + 1 )); f++)); do
    letters[$jj]="${some_letters:$jj:1}"
    jj=$(( $jj + 1 ))
  done
   
  if [[ $length_random -lt $idx2 ]]; then
    for ((a=o; a<$(( $idx1 )); a++)); do # Печатаем последний(-ие) символ(-ы)
      name="$last$name";
    done
   
    for (( k=$idx2; k>=0; k-- )); do # Допечатываем оставшийся шаблон
      ii=$(( $k - 1 ))
      name="${letters[$ii]}$name"
    done
  
  elif [[ $idx -eq 1 ]]; then
    name="$folder_names"
  fi
  
  echo "$name"
}

function check_storage() { 
  local avialable=$(df --output=avail / | tail -1) # Проверка доступного места на диске
  if [[ $avialable -lt 1048576 ]]; then # Если доступное место меньше 1 Мбайта
    echo "Error: There is not enough free disk space to complete this operation"
    exit 1
  fi
}

function create_subfolders_with_files() {
  subfolder_name="" 
  file_name=""
  
  for ((i=0; i<$number_subfolders; i++)); do 
        tmp_foldname="$(name_generator $i $length_fol $folder_names $last_fol_sym)" # Генерация имени подпапки
        subfolder_name="${tmp_foldname}_${suff}"
        local subfolder_path="${absolute_path}/${subfolder_name}"
        mkdir -p "$subfolder_path" # Создание подпапки (-p - создает все директории, указанные в пути. Если директория уже существует, то предупреждение не выводится)
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) created folder ${absolute_path}/${subfolder_name}" >> log_file.txt

    for ((j=0; j<$number_files; j++)); do # Создание файлов в папке
        check_storage
        tmp_filename="$(name_generator $j $length_file $list_letters_start $last_file_sym)" # Генерация имени файла
        file_name="${tmp_filename}.${list_letters_end}" 
        local file_path="${absolute_path}/${subfolder_name}/${file_name}" 
        truncate -s "$((file_size * 1024))" "$file_path" # Создание файла указанного размерв Кб
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) created file ${absolute_path}/${subfolder_name}/${file_name} ${file_size}Kb" >> log_file.txt
    done
  done
  
}

function create() {
  touch log_file.txt # Создание файла журнала
  create_subfolders_with_files # Создание подпапок с файлами
}

create # Запуск программы