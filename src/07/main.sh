#!/bin/bash

if [ $# != 0 ] ; then
    echo "Error: Не принимаются аргументы командной строки" # Выводим ошибку, если переданы аргументы командной строки
    exit 1
fi

##### Обновление системы #####
sudo apt-get update
sudo apt-get upgrade

##### Установка Grafana #####
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_10.0.3_amd64.deb
sudo dpkg -i grafana-enterprise_10.0.3_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server


##### Установка Prometheus #####
sudo apt-get install prometheus
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus


##### Установка node_exporter #####
tar xvf node_exporter-1.3.1.linux-amd64.tar.gz
cd node_exporter-1.3.1.linux-amd64
sudo cp node_exporter /usr/local/bin
cd ..
rm -rf ./node_exporter-1.3.1.linux-amd64

sudo useradd --no-create-home --shell /bin/false node_exporter
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

cp node_exporter.service /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter

##### Тестирование системы #####
stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s