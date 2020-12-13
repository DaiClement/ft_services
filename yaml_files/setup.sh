#!/usr/bin/env zsh

install()
{
	#installation from https://kubernetes.io/docs/tasks/tools/install-kubectl/
	echo install kubectl:;
	sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl;
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list;
	sudo apt-get update;
	sudo apt-get install -y kubectl;

	#installation from https://minikube.sigs.k8s.io/docs/start/;
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb;
	sudo dpkg -i minikube_latest_amd64.deb;
	rm minikube_latest_amd64.deb;



	#install filezilla
	sudo apt-get install -y filezilla;

	#get metallb manifest
	curl https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml > metallb_config.yaml
	echo '---' >> metallb_config.yaml
	curl https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml >> metallb_config.yaml

	#make docker group and add $USER to docker group. Needed for permission
	if [[ $(groups | grep docker) = '' ]]
		then
		sudo usermod -aG docker $USER
	fi
}

clear_all()
{
	minikube stop;
	minikube delete --all;
	docker system prune -af;
}

build()
{
	docker build -t nginx-alpine ../docker_images/nginx/;
}

launch_ft_services()
{
	minikube start --driver=docker --cpus=3 --memory=3000;
	kubectl apply -f metallb_config.yaml;
	minikube addons enable metrics-server;
	minikube addons enable metallb;
	kubectl apply -f metallb_layer2.yaml;
	eval $(minikube -p minikube docker-env);
	docker build -t nginx-alpine ../docker_images/nginx/;
	docker build -t mysql-alpine ../docker_images/mysql/;
	docker build -t wp-alpine ../docker_images/wp/;
	kubectl apply -f nginx.yaml;
	kubectl apply -f mysql.yaml;
	kubectl apply -f wp.yaml;
}

#install
#clear_all
#build
launch_ft_services
