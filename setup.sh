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
	if [ ! -f "/tmp/cdai_config" ];
	then
		minikube stop || echo -n;
		minikube delete --all || echo -n;
		touch /tmp/cdai_config;
	fi

	check_shell_version
	check_minimum_requirement;
	check_software_version;

	echo download and/or start minikube can take a while - please wait
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

	echo $'\n\n'
	get_log
}

get_log()
{
	echo LOGIN/PASSWORD$'\n'
	echo 'for nginx (by ssh)'
	echo login: user42$'\t\t''|'$'\t'password: user42$'\n'

	echo for phpmyadmin
	echo login: admin$'\t\t''|'$'\t'password: pass
	echo login: wp-admin$'\t\t''|'$'\t'password: pass$'\n'

	echo for wordpress
	echo login: admin$'\t\t''|'$'\t'password: pass
	echo login: Author$'\t\t''|'$'\t'password: pass
	echo login: contributor$'\t''|'$'\t'password: pass
	echo login: Editor$'\t\t''|'$'\t'password: pass
	echo login: subscriber$'\t''|'$'\t'password: pass$'\n'

	echo for grafana
	echo login: admin$'\t\t''|'$'\t'password: $'pass\n'

	echo for ftps
	echo login: root$'\t\t''|'$'\t'password: 'pass'
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
	elif [ $nbCpus -lt 2 ]; then
		echo Not enough cpus
		exit 1
	elif [ $freeSpace -le 5000000 ]; then
		echo Not enough free spaces
		exit 1
	fi
	
	if [ "$(groups | grep docker)" = "" ]
	then
		#add user42 to docker group
		sudo usermod -aG docker $USER
		echo session will close in 10second to update \'docker\' group
		echo please reconnect and launch ft_services again
		sleep 10

		#auto deconnection
		sudo kill -9 \
		$( \
			echo \
			$( \
				ps -ft \
				$( \
					w | grep user42 | awk '{print $2}' \
				) \
			) | grep root | awk '{print $10}' \
		)
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

install_minikube()
{
	minikube_version=$(minikube version | grep minikube | awk '{print $3}')
	echo minikube version: $minikube_version
	
	if [ "$minikube_version" != "v1.9.0" ]; then
		curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.9.0/minikube-linux-amd64 && chmod +x minikube
		sudo mkdir -p /usr/local/bin/
		sudo install minikube /usr/local/bin/
	else
		echo minikuibe is already in version $minikube_version
	fi
}

install_kubectl()
{
	kubectl_version=$(kubectl version --client | awk '{print $5}')
	echo -n 'kubectl version: '
	kubectl_version=$(echo $kubectl_version | cut -c "13-$(expr $(echo $kubectl_version | wc -c) - 3)")
	echo $kubectl_version
	
	if [ "$kubectl_version" != "v1.18.0" ]; then
		curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
		sudo chmod +x ./kubectl
		sudo mv ./kubectl /usr/local/bin/kubectl
	else
		echo kubectl is already in version $kubectl_version
	fi
}

if [ "$1" = "re" ]
then
	minikube stop >> $log_file 2>> $error_file ;
	minikube delete >> $log_file 2>> $error_file ;
	launch_ft_services;
elif [ "$1" = "" ]
then
	launch_ft_services;
elif [ "$1" = "new_ssh_key" ]
then
	cat /dev/zero | ssh-keygen -q -t rsa -b 4096 -N '' 2>&1 >/dev/null
	cat ~/.ssh/id_rsa.pub
	sleep 10 &
	firefox -url signin.intra.42.fr > /dev/null 2>&1 &
	sleep 20 &
	firefox -url https://profile.intra.42.fr/gitlab_users/new > /dev/null 2>&1 &
elif [ "$1" = "minikube" ]
then
	install_minikube
elif [ "$1" = "kubectl" ]
then
	install_kubectl
elif [ "$1" = "get_log" ]
then
	get_log
elif [ "$1" = "fix42VM" ]
then
	# source: https://itsfoss.com/could-not-get-lock-error/
	sudo kill -9 $(sudo lsof /var/lib/dpkg/lock-frontend 2> /dev/null | grep unattende | awk '{print $2}') 2>/dev/null  >/dev/null || echo -n
	sudo rm /var/lib/dpkg/lock-frontend
	sudo dpkg --configure -a
elif [ "$1" = "filezilla" ]
then
	sudo apt-get install -y filezilla
	filezilla 2>&1 >/dev/null &
else
	echo \"$1\" is not a valid argument
	exit 1
fi

