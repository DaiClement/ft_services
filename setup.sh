#!/usr/bin/env zsh

install()
{
	#installation from https://kubernetes.io/docs/tasks/tools/install-kubectl/
#	echo install kubectl:;
#	sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl;
#	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
#	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list;
#	sudo apt-get update;
#	sudo apt-get install -y kubectl;

	#installation from https://minikube.sigs.k8s.io/docs/start/;
#	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb;
#	sudo dpkg -i minikube_latest_amd64.deb;
#	rm minikube_latest_amd64.deb;



	#install filezilla
#	sudo apt-get install -y filezilla;

	#get metallb manifest
#	curl https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml > metallb_config.yaml
#	echo '---' >> metallb_config.yaml
#	curl https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml >> metallb_config.yaml

	#make docker group and add $USER to docker group. Needed for permission
	if [[ $(groups | grep docker) = '' ]]
	then
		sudo usermod -aG docker $USER
	fi
}

launch_ft_services()
{
	echo minikube start
	minikube start --driver=docker --cpus=2 --memory=2000 2>&1 > /dev/null;
	echo minikube started;
	minikube dashboard 2>&1 > /dev/null &
	echo launch dashboard;
#	kubectl apply -f metallb_config.yaml;
	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml > /dev/null
	kubectl apply -f ./yaml_files/metallb_layer2.yaml > /dev/null ;
	echo setup metallb;
	minikube addons enable metrics-server > /dev/null ;
#	minikube addons enable metallb;
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

echo $(grep MemTotal /proc/meminfo | awk '{print $2}') bytes of ram '|' Need 2Go of ram;
echo $(grep 'cpu cores' /proc/cpuinfo | uniq | awk '{print $4}') cpus '|' Need 2 free cpus;
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
fi
