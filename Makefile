NAME			= ft_services

NGINX_ALPINE	= nginx_alpine
MYSQL_ALPINE	= mysql_alpine
PMA_ALPINE		= pma_alpine
WP_ALPINE		= wp_alpine
GRAFANA_ALPINE	= grafana_alpine
INFLUXDB_ALPINE	= influxdb_alpine
FTPS_ALPINE		= ftps_alpine


all:	$(NAME)

$(NAME):
	./setup.sh

clean: stop delete clean_docker

fclean:	clean prune

stop_service:
	echo "user42" | sudo -S service mysql stop;
	echo "user42" | sudo -S service nginx stop;
#	echo "user42" | sudo -S service sshd stop;

clean_docker:
	docker kill $$(docker ps -aq) || echo -n
	docker rm $$(docker ps -aq) || echo -n

re:
	./setup.sh re

start:
	minikube start --driver=docker --cpus=2 --memory=2000

stop:
	minikube stop || echo -n;

delete:
	minikube delete --all || echo -n;

prune:
	docker system prune -af

ps:
	docker ps

ifeq (exec,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

exec:
#	docker exec -ti $(RUN_ARGS)_alpine sh
	kubectl exec --stdin --tty \
	$$(kubectl get pods | grep $(RUN_ARGS) | cut -c \
		-$$(expr $$(echo -n $(RUN_ARGS) | wc -c) + 28) \
		) -- sh

config:
	git config --global user.email "cdai@student.42.fr";
	git config --global user.name "cdai";
	git clone https://github.com/42paris/42header;
	mkdir -p ~/.vim/plugin;
	sed 's/marvin/cdai/' 42header/vim/stdheader.vim | sed 's/42.fr/student.42.fr/' > ~/.vim/plugin/stdheader.vim;
	git config --global core.editor vim;
	rm -rf 42header;
	echo *.log > .gitignore
	echo .*.swp >> .gitignore

ifeq (search,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

search:
	grep -n $(RUN_ARGS) ./* ./*/* ./*/*/* 2> /dev/null

firefox:
	firefox 2>&1 > /dev/null &

fix42VM:
	# source: https://itsfoss.com/could-not-get-lock-error/
	sudo kill -9 $$(sudo lsof /var/lib/dpkg/lock-frontend 2> /dev/null | grep unattende | awk '{print $$2}')
	sudo rm /var/lib/dpkg/lock-frontend
	sudo dpkg --configure -a


.PHONY:	all clean fclean re build run prune exec config search ps
