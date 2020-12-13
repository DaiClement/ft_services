NAME			= ft_services

NGINX_ALPINE	= nginx-alpine
MYSQL_ALPINE	= mysql-alpine
PMA_ALPINE		= pma-alpine
WP_ALPINE		= wp-alpine
GRAFANA_ALPINE	= grafana_alpine
INFLUXDB_ALPINE	= influxdb_alpine
FTPS_ALPINE		= ftps_alpine


all:	$(NAME)

$(NAME): build run

clean:
	docker kill $$(docker ps -aq) || echo -n
	docker rm $$(docker ps -aq) || echo -n

fclean:	clean
	echo "user42" | sudo -S service mysql stop;
	echo "user42" | sudo -S service nginx stop;
	echo "user42" | sudo -S service sshd stop;

re:				fclean all

build:
	docker build -t $(MYSQL_ALPINE) mysql/
	docker build -t $(NGINX_ALPINE) nginx/
	docker build -t $(PMA_ALPINE) pma/
	docker build -t $(WP_ALPINE) wp/
#	docker build -t $(GRAFANA_ALPINE) grafana/
#	docker build -t $(INFLUXDB_ALPINE) influxdb/
#	docker build -t $(FTPS_ALPINE) ftps/

run:
	docker run -dti --name $(MYSQL_ALPINE) $(MYSQL_ALPINE)
	docker run -dti -p 127.0.0.1:5000:5000 --name $(PMA_ALPINE) --link $(MYSQL_ALPINE):db $(PMA_ALPINE)
	docker run -dti -p 127.0.0.1:5050:5050 --name $(WP_ALPINE) --link $(MYSQL_ALPINE):db $(WP_ALPINE)
	docker run -dti -p 127.0.0.1:80:80 -p 127.0.0.1:443:443 -p 127.0.0.1:22:22 --link $(PMA_ALPINE) --name $(NGINX_ALPINE) $(NGINX_ALPINE)
#	docker run -dti --name $(INFLUXDB_ALPINE) -v /var/run/docker.sock:/var/run/docker.sock $(INFLUXDB_ALPINE)
#	docker run -dti -p 127.0.0.1:3000:3000 --name $(GRAFANA_ALPINE) --link $(INFLUXDB_ALPINE) $(GRAFANA_ALPINE)
#	docker run -dti -p 127.0.0.1:21:21 --name $(FTPS_ALPINE) $(FTPS_ALPINE)

prune:
	docker system prune -af

ps:
	docker ps

ifeq (exec,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

exec:
	docker exec -ti $(RUN_ARGS)-alpine sh

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
