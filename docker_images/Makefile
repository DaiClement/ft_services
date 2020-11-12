NAME 		= ft_services

NGINX_ALPINE	= nginx_alpine
MYSQL_ALPINE	= mysql_alpine
PMA_ALPINE	= pma_alpine
WP_ALPINE	= wp_alpine
GRAFANA_ALPINE	= grafana_alpine
INFLUXDB_ALPINE	= influxdb_alpine


all:	$(NAME)		

$(NAME): build run
	
clean:
	docker kill $(NGINX_ALPINE) $(MYSQL_ALPINE) $(PMA_ALPINE) $(WP_ALPINE) || echo -n
	docker rm $(NGINX_ALPINE) $(MYSQL_ALPINE) $(PMA_ALPINE) $(WP_ALPINE) || echo -n
		
fclean:	clean
	echo "user42" | sudo -S service mysql stop;
	echo "user42" | sudo -S service nginx stop;
	
re:				fclean all

ifeq (build,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

build:
	docker build -t $(NGINX_ALPINE) nginx/
	docker build -t $(MYSQL_ALPINE) mysql/
	docker build -t $(PMA_ALPINE) pma/
	docker build -t $(WP_ALPINE) wp/

ifeq (build,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

run:
	docker run -d --name $(MYSQL_ALPINE) $(MYSQL_ALPINE)
	docker run -d -p 127.0.0.1:8080:80 --name $(NGINX_ALPINE) $(NGINX_ALPINE)
	docker run -d -p 127.0.0.1:5000:5000 --name $(PMA_ALPINE) --link $(MYSQL_ALPINE):db $(PMA_ALPINE)
	docker run -d -p 127.0.0.1:5050:5050 --name $(WP_ALPINE) --link $(MYSQL_ALPINE):db $(WP_ALPINE)

prune:
	docker system prune -af

ifeq (exec,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

exec:
	docker exec -ti $(RUN_ARGS)_alpine sh

config:
	git config --global user.email "cdai@student.42.fr";
	git config --global user.name "cdai";
	sed 's/marvin/cdai/' 42header/vim/stdheader.vim | sed 's/42.fr/student.42.fr/' > ~/.vim/plugin/stdheader.vim;

ifeq (search,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

search:
	grep -n $(RUN_ARGS) srcs/*.c headers/*.h libft/*/*.c libft/*/*.h

.PHONY:	all clean fclean re build run prune exec config search
