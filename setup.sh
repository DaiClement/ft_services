#!/bin/bash

log_files=ft_services.log

launch_ft_services()
{
	echo download minikube can take a while
	minikube start --driver=docker --cpus=2 --memory=2000 2>&1 > $log_files;
	echo minikube started;

	minikube dashboard 2>&1 >> $log_files &
	echo launch dashboard;

	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml >> $log_files
	kubectl apply -f ./yaml_files/metallb_layer2.yaml >> $log_files ;
	echo setup metallb;

	minikube addons enable metrics-server >> $log_files ;
	eval $(minikube -p minikube docker-env) >> $log_files ;

	docker build -t nginx-alpine ./docker_images/nginx/ >> $log_files ; 
	kubectl apply -f ./yaml_files/nginx.yaml >> $log_files ;
	echo nginx started;

	docker build -t mysql-alpine ./docker_images/mysql/ >> $log_files ;
	kubectl apply -f ./yaml_files/mysql.yaml >> $log_files ;
	echo mysql started;

	docker build -t wp-alpine ./docker_images/wp/ >> $log_files ;
	kubectl apply -f ./yaml_files/wp.yaml >> $log_files ;
	echo wordpress started;

	docker build -t pma-alpine ./docker_images/pma/ >> $log_files ;
	kubectl apply -f ./yaml_files/pma.yaml >> $log_files ;
	echo phpmyadmin started;

	docker build -t influxdb-alpine ./docker_images/influxdb/ >> $log_files ;
	kubectl apply -f ./yaml_files/influxdb.yaml >> $log_files ;
	echo influxdb started;

	docker build -t grafana-alpine ./docker_images/grafana/ >> $log_files ;
	kubectl apply -f ./yaml_files/grafana.yaml >> $log_files ;
	echo grafana started;

	docker build -t ftps-alpine ./docker_images/ftps/ >> $log_files ;
	kubectl apply -f ./yaml_files/ftps.yaml >> $log_files ;
	echo ftps started;
}

get_log(){
	echo for phpmyadmin
	echo login: admin '|' password: pass
	echo login: wp-admin '|' password: pass'\n'

	echo for wordpress
	echo login: wp-admin '|' password:pass
	echo login: Author '|' password:pass
	echo login: contributor '|' password:pass
	echo login: Editor '|' password:pass
	echo login: subscriber '|' password:pass'\n'

	echo for grafana
	echo login: admin '|' password: 'admin\n'

	echo for ftps
	echo login: root '|' password: 'pass'
}

memTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')
nbCpus=$(grep 'cpu cores' /proc/cpuinfo | uniq | awk '{print $4}')
freeSpace=$(df | grep /dev/sda1 | awk '{print $4}')

echo $memTotal bytes ram memory
echo $nbCpus cpus
echo $freeSpace bytes of free spaces

if [ $memTotal -le 4000000 ]; then
	echo Not enough RAM
	exit 1
elif [ $nbCpus -lt 4 ]; then
	echo Not enough cpus
	exit 1
elif [ $freeSpace -le 5000000 ]; then
	echo Not enough free spaces
	exit 1
fi

if [[ $(groups | grep docker) = '' ]]
then
	sudo usermod -aG docker $USER
	echo "close session and reconnect to update 'docker' group"
	exit
fi

if [ "$1" = "re" ]
then
	minikube stop >> $log_files ;
	minikube delete >> $log_files ;
	launch_ft_services;
elif [ "$1" = "" ]
then
	launch_ft_services;
else
	echo \"$1\" is not an argument
	exit 1
fi
get_log
