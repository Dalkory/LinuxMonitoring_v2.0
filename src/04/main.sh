#!/bin/bash

if [ $# != 0 ] ; then
    echo "Error: Не принимаются аргументы командной строки" # Выводим ошибку, если переданы аргументы командной строки
    exit 1
fi

# CONSTANT VALUES
min_number_of_records=100
max_number_of_records=1000
diapazon_of_records=$(($max_number_of_records-$min_number_of_records))  # Разница между максимальным и минимальным количеством записей
column_for_sorting=4  # Номер столбца для сортировки
number_of_files=5  # Количество файлов журналов
max_years_ago=10  # Максимальное количество лет назад
resource="https://translate.google.com/?hl=ru"  # URL ресурса
protocol="HTTP/1.1"  # Протокол запроса
url_from="https://ru.wikipedia.org/wiki/Google_%D0%9F%D0%B5%D1%80%D0%B5%D0%B2%D0%BE%D0%B4%D1%87%D0%B8%D0%BA"  # Исходный URL
max_bytes=8192  # Максимальный размер объекта в байтах

# ARRAYS WITH VALUES FOR LOG
response_codes=('200' '201' '400' '401' '403' '404' '500' '501' '502' '503')  # Массив кодов ответов
methods=('GET' 'POST' 'PUT''PATCH' 'DELETE')  # Массив методов запроса
agents=('Mozilla' 'Google Chrome' 'Opera Safari' 'Internet Explorer' 'Microsoft Edge' 'Crawler and bot' 'Library and net tool')  # Массив заголовков User-Agent

# LENGTH OF DECLARED ARRAYS:
response_codes_length=${#response_codes[*]}  # Длина массива кодов ответов
methods_length=${#methods[*]}  # Длина массива методов запроса
agents_length=${#agents[*]}  # Длина массива заголовков User-Agent

generate_date() {
    let days_backwards=$RANDOM%31  # Случайное количество дней назад
    let months_backwards=$RANDOM%11  # Случайное количество месяцев назад
    let years_backwards=$RANDOM%$max_years_ago  # Случайное количество лет назад
    date_ago="-$days_backwards days -$months_backwards months -$years_backwards years"  # Строка с отрицательными значениями для генерации даты в прошлом
    date=$(date -d "$date_ago" '+%d/%b/%Y')  # Генерация даты в формате день/месяц/год
}

generate_time(){
    let hours=$RANDOM%24  # Случайное количество часов
    let minutes=$RANDOM%60  # Случайное количество минут
    let seconds=$RANDOM%60  # Случайное количество секунд
    time_ago="-$seconds seconds -$minutes minutes -$hours hours"  # Строка с отрицательными значениями для генерации времени в прошлом
    time=$(date -d "$time_ago" '+%H:%M:%S %z')  # Генерация времени в формате часы:минуты:секунды часового пояса
}

file_counter=1
while [ $file_counter -le $number_of_files ]
do
    export LANG=""
    log_counter=0
    log_file="access$file_counter.log"  # Имя файла журнала доступа
    sudo touch $log_file && chmod 777 $log_file  # Создание и разрешение для файла журнала доступа
    number_of_logs=$(($RANDOM%$diapazon_of_records+$min_number_of_records))  # Случайное количество записей в журнале
    generate_date
    while [ $log_counter -lt $number_of_logs ]
    do
        let i_rc=$RANDOM%$response_codes_length  # Случайный индекс для выбора кода ответа из массива
        let i_m=$RANDOM%$methods_length  # Случайный индекс для выбора метода запроса из массива
        let i_a=$RANDOM%$agents_length  # Случайный индекс для выбора заголовка User-Agent из массива
        let object_size=$RANDOM%$max_bytes
        generate_time
        ip="$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256))"  # Генерация случайного IP-адреса
        echo "$ip - $USER [$date:$time] \"${methods[i_m]} $resource $protocol\" ${response_codes[i_rc]} $object_size \"$url_from\" \"${agents[i_a]}\""  # Вывод строки журнала доступа
        log_counter=$(($log_counter+1))
    done > $log_file
    sudo touch buffer && chmod 777 buffer
    sort --key=$column_for_sorting $log_file > buffer  # Сортировка файла журнала по указанному столбцу
    cat buffer > $log_file && sudo rm buffer
    file_counter=$(($file_counter+1))
done