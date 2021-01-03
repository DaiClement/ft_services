NAME			= ft_services

NGINX_ALPINE	= nginx_alpine
MYSQL_ALPINE	= mysql_alpine
PMA_ALPINE		= pma_alpine
WP_ALPINE		= wp_alpine
GRAFANA_ALPINE	= grafana_alpine
INFLUXDB_ALPINE	= influxdb_alpine
FTPS_ALPINE		= ftps_alpine


all:	$(NAME)

$(NAME): stop_service start
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
	minikube start --driver=docker --cpus=3 --memory=2200

stop:
	minikube stop;

delete:
	minikube delete --all;

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
	$$(kubectl get pods | grep $(RUN_ARGS)-deployment | cut -c \
		-$$(expr $$(echo -n $(RUN_ARGS) | wc -c) + 28) \
		) -- sh

config:
	git config --global user.email "cdai@student.42.fr";
	git config --global user.name "cdai";
	sed 's/marvin/cdai/' 42header/vim/stdheader.vim | sed 's/42.fr/student.42.fr/' > ~/.vim/plugin/stdheader.vim;

ifeq (search,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

search:
	grep -n $(RUN_ARGS) ./* ./*/* ./*/*/* 2> /dev/null

firefox:
	firefox 2>&1 > /dev/null &

.PHONY:	all clean fclean re build run prune exec config search ps
