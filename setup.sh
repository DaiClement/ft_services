#!/usr/bin/env zsh

launch_ft_services()
{
	minikube start --driver=docker --cpus=2 --memory=2000 2>&1 > /dev/null;
	echo minikube started;

	minikube dashboard 2>&1 > /dev/null &
	echo launch dashboard;

	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml > /dev/null
	kubectl apply -f ./yaml_files/metallb_layer2.yaml > /dev/null ;
	echo setup metallb;

	minikube addons enable metrics-server > /dev/null ;
	eval $(minikube -p minikube docker-env) > /dev/null ;

	docker build -t nginx-alpine ./docker_images/nginx/ > /dev/null ; 
	kubectl apply -f ./yaml_files/nginx.yaml > /dev/null ;
	echo nginx started;

	docker build -t mysql-alpine ./docker_images/mysql/ > /dev/null ;
	kubectl apply -f ./yaml_files/mysql.yaml > /dev/null ;
	echo mysql started;

	docker build -t wp-alpine ./docker_images/wp/ > /dev/null ;
	kubectl apply -f ./yaml_files/wp.yaml > /dev/null ;
	echo wordpress started;

	docker build -t pma-alpine ./docker_images/pma/ > /dev/null ;
	kubectl apply -f ./yaml_files/pma.yaml > /dev/null ;
	echo phpmyadmin started;

	docker build -t influxdb-alpine ./docker_images/influxdb/ > /dev/null ;
	kubectl apply -f ./yaml_files/influxdb.yaml > /dev/null ;
	echo influxdb started;

	docker build -t grafana-alpine ./docker_images/grafana/ > /dev/null ;
	kubectl apply -f ./yaml_files/grafana.yaml > /dev/null ;
	echo grafana started;

	docker build -t ftps-alpine ./docker_images/ftps/ > /dev/null ;
	kubectl apply -f ./yaml_files/ftps.yaml > /dev/null ;
	echo ftps started;

}

memTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')
nbCpus=$(grep 'cpu cores' /proc/cpuinfo | uniq | awk '{print $4}')
freeSpace=$(expr $(df | grep /dev/sda1 | awk '{print $4}'))

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
	minikube stop > /dev/null ;
	minikube delete > /dev/null ;
	launch_ft_services;
elif [ "$1" = "" ]
then
	launch_ft_services;
else
	echo \"$1\" is not an argument
	exit 1
fi
