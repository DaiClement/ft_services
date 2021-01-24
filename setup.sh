#!/bin/bash

log_file=ft_services.log
error_file=error.log

check_shell_version()
{
	if [ "$(ps | grep $$ | awk '{print $4}')" != "bash" ] && [ "$(ps | grep $$ | awk '{print $4}')" != "setup.sh" ]
	then
		echo Your shell is $(ps | grep $$ | awk '{print $4}')
		echo Please use bash
		exit
	fi
}

launch_ft_services()
{
	echo download minikube can take a while - please wait
	minikube start --driver=docker --cpus=2 --memory=2000 > $log_file 2> $error_file;
	echo minikube started;

	minikube dashboard >> $log_file 2>> $error_file &
	echo launch dashboard;

	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml >> $log_file 2>> $error_file ;
	kubectl apply -f ./srcs/yaml_files/metallb_layer2.yaml >> $log_file 2>> $error_file ;
	echo setup metallb;

	minikube addons enable metrics-server >> $log_file 2>> $error_file ;
	eval $(minikube -p minikube docker-env) >> $log_file 2>> $error_file ;

	docker build -t nginx-alpine ./srcs/docker_images/nginx/ >> $log_file 2>> $error_file ; 
	kubectl apply -f ./srcs/yaml_files/nginx.yaml >> $log_file 2>> $error_file ;
	echo nginx started;

	docker build -t mysql-alpine ./srcs/docker_images/mysql/ >> $log_file 2>> $error_file ;
	kubectl apply -f ./srcs/yaml_files/mysql.yaml >> $log_file 2>> $error_file ;
	echo mysql started;

	docker build -t wp-alpine ./srcs/docker_images/wp/ >> $log_file 2>> $error_file ;
	kubectl apply -f ./srcs/yaml_files/wp.yaml >> $log_file 2>> $error_file ;
	echo wordpress started;

	docker build -t pma-alpine ./srcs/docker_images/pma/ >> $log_file 2>> $error_file ;
	kubectl apply -f ./srcs/yaml_files/pma.yaml >> $log_file 2>> $error_file ;
	echo phpmyadmin started;

	docker build -t influxdb-alpine ./srcs/docker_images/influxdb/ >> $log_file 2>> $error_file ;
	kubectl apply -f ./srcs/yaml_files/influxdb.yaml >> $log_file 2>> $error_file ;
	echo influxdb started;

	docker build -t grafana-alpine ./srcs/docker_images/grafana/ >> $log_file 2>> $error_file ;
	kubectl apply -f ./srcs/yaml_files/grafana.yaml >> $log_file 2>> $error_file ;
	echo grafana started;

	docker build -t ftps-alpine ./srcs/docker_images/ftps/ >> $log_file 2>> $error_file ;
	kubectl apply -f ./srcs/yaml_files/ftps.yaml >> $log_file 2>> $error_file ;
	echo ftps started;
}

get_log(){
	echo for phpmyadmin
	echo login: admin '|' password: pass
	echo login: wp-admin '|' password: pass$'\n'

	echo for wordpress
	echo login: wp-admin '|' password:pass
	echo login: Author '|' password:pass
	echo login: contributor '|' password:pass
	echo login: Editor '|' password:pass
	echo login: subscriber '|' password:pass$'\n'

	echo for grafana
	echo login: admin '|' password: $'admin\n'

	echo for ftps
	echo login: root '|' password: 'pass'
}

check_minimum_requirement()
{
	memTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')
	nbCpus=$(grep 'cpu cores' /proc/cpuinfo | uniq | awk '{print $4}')
	freeSpace=$(df | grep /dev/sda1 | awk '{print $4}')

	echo $memTotal bytes ram memory
	echo $nbCpus cpus
	echo $freeSpace bytes of free spaces$'\n'

	if [ $memTotal -le 2900000 ]; then
		echo Not enough RAM
		exit 1
	elif [ $nbCpus -lt 3 ]; then
		echo Not enough cpus
		exit 1
	elif [ $freeSpace -le 5000000 ]; then
		echo Not enough free spaces
		exit 1
	fi
	
	if [ '$(groups | grep docker)' = '' ]
	then
		sudo usermod -aG docker $USER
		echo "close session and reconnect to update 'docker' group"
		exit
	fi
}

check_software_version()
{
	minikube_version=$(minikube version | grep minikube | awk '{print $3}')
	echo minikube version: $minikube_version

	kubectl_version=$(kubectl version --client | awk '{print $5}')
	echo -n 'kubectl version: '
	kubectl_version=$(echo $kubectl_version | cut -c "13-$(expr $(echo $kubectl_version | wc -c) - 3)")
	echo $kubectl_version

	echo -n 'docker version: '
	docker_version=$(docker -v | awk '{print $3}')
	docker_version=$(echo $docker_version | cut -c "-$(expr $(echo $docker_version | wc -c) - 2)")
	echo $docker_version

	if [ "$minikube_version" != "v1.9.0" ]; then
		echo Please use minikube v1.9.0.$'\n'Install it with make install minikube or use a fresh new 42VM.
		exit 1
	elif [ "$kubectl_version" != "v1.18.0" ]; then
		echo Please use kubectl version v1.18.0.$'\n'Install it with make install kubectl or use a fresh new 42VM.
		exit 1
	fi
	echo
}

if [ "$1" = "re" ]
then
	minikube stop >> $log_file 2>> $error_file ;
	minikube delete >> $log_file 2>> $error_file ;
	check_shell_version
	check_minimum_requirement;
	check_software_version;
	launch_ft_services;
elif [ "$1" = "" ]
then
	check_shell_version
	check_minimum_requirement;
	check_software_version;
	launch_ft_services;
elif [ "$1" = "new_ssh_key" ]
then
	cat /dev/zero | ssh-keygen -q -t rsa -b 4096 -N '' 2>&1 >/dev/null
	cat ~/.ssh/id_rsa.pub
	sleep 10 &
	firefox -url signin.intra.42.fr > /dev/null 2>&1 &
	sleep 20 &
	firefox -url https://profile.intra.42.fr/gitlab_users/new > /dev/null 2>&1 &
	exit
elif [ "$1" = "minikube" ]
then
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.9.0/minikube-linux-amd64 && chmod +x minikube
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
	exit
elif [ "$1" = "kubectl" ]
then
	curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
	sudo chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
	exit
else
	echo \"$1\" is not a valid argument
	exit 1
fi

echo $'\n\n'
get_log
