NAME	= ft_services

all:	$(NAME)

$(NAME):
	./setup.sh

clean: stop 

fclean:	clean delete

re:
	./setup.sh re

stop:
	minikube stop || echo -n;

delete:
	minikube delete --all || echo -n;

ifeq (exec,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

exec:
	kubectl exec --stdin --tty \
	$$(\
		kubectl get pods | grep $(RUN_ARGS) | cut -c \
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
	echo '*.log' > .gitignore
	echo '.*.swp' >> .gitignore
	echo .gitignore >> .gitignore

ifeq (search,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

search:
	grep -n $(RUN_ARGS) ./* ./*/* ./*/*/* 2> /dev/null

firefox:
	firefox 2>&1 > /dev/null &

fix42VM:
	./setup.sh fix42VM

new_ssh_key:
	./setup.sh new_ssh_key

filezilla: fix42VM
	./setup.sh filezilla

ifeq (install,$(firstword $(MAKECMDGOALS)))
    RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(RUN_ARGS):;@:)
endif

install:
	./setup.sh $(RUN_ARGS)

get_log:
	./setup.sh get_log

.PHONY:	all clean fclean re exec config search firefox fix42VM new_ssh_key filezilla install get_log
