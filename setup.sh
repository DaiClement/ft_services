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
	minikube start --driver=docker --cpus=2 --memory=3000;
	minikube dashboard &
#	kubectl apply -f metallb_config.yaml;
	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
	minikube addons enable metrics-server;
#	minikube addons enable metallb;
	kubectl apply -f ./yaml_files/metallb_layer2.yaml;
	eval $(minikube -p minikube docker-env);
	docker build -t nginx-alpine ./docker_images/nginx/;
	kubectl apply -f ./yaml_files/nginx.yaml;
	docker build -t mysql-alpine ./docker_images/mysql/;
	kubectl apply -f ./yaml_files/mysql.yaml;
	docker build -t wp-alpine ./docker_images/wp/;
	kubectl apply -f ./yaml_files/wp.yaml;
	docker build -t pma-alpine ./docker_images/pma/;
	kubectl apply -f ./yaml_files/pma.yaml;
	docker build -t influxdb-alpine ./docker_images/influxdb/;
	kubectl apply -f ./yaml_files/influxdb.yaml;
	docker build -t grafana-alpine ./docker_images/grafana/;
	kubectl apply -f ./yaml_files/grafana.yaml;
	docker build -t ftps-alpine ./docker_images/ftps/;
	kubectl apply -f ./yaml_files/ftps.yaml;
}


if [[ $(groups | grep docker) = '' ]]
then
	sudo usermod -aG docker $USER
	echo "close session and reconnect to update 'docker' group"
	exit
fi
if [ "$1" = "re" ]
then
	minikube stop;
	minikube delete;
	launch_ft_services;
elif [ "$1" = "" ]
then
	launch_ft_services;
else
	echo \"$1\" is not an argument
fi
