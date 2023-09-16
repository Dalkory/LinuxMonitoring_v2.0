function check_parameters {
    # Проверка наличия трех параметров
    if [[ $param -le 0 ]]; then
        echo "Error: Enter 3 parameters (example: az az.az 3Mb)"
        exit 1
    fi

    # Проверка первого параметра
    if [ -z "$folder_names" ]; then
        echo "Error: 1 parameter not provided!"
        exit 1
    # Проверка, что первый параметр состоит только из английских букв и не превышает 7 символов
    elif [[ ! "$folder_names" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "Error: 1 parameter should be a string of English letters and not exceed 7 characters!"
        exit 1
    fi

    # Проверка второго параметра
    if [ -z "$letters_file_name_ext" ]; then
        echo "Error: 2 not provided!"
        exit 1
    # Проверка, что второй параметр соответствует формату 'filename.extension' и не превышает ограничения по длине
    elif [[ ! "$letters_file_name_ext" =~ ^[a-zA-Z]{1,7}.[a-zA-Z]{1,3}$ ]]; then
        echo "Error: 2 should be in the format 'filename.extension' where both filename and extension consist of English letters, file name no more than 7 characters and extension no more than 3!"
        exit 1
    fi

    # Проверка третьего параметра
    if [ -z "$file_size" ]; then
        echo "Error: 3 parameter not provided!"
        exit 1
    # Проверка, что третий параметр является числовым значением и не превышает 100
    elif ! [[ "$file_size" =~ ^[0-9]+$ ]] || [ "$file_size" -gt 100 ]; then
        echo "Error: 3 should be a numeric value not exceeding 100 MB!"
        exit 1
    fi
}

# Вызов функции для проверки параметров
check_parameters