FROM	alpine:latest

ADD		./srcs /tmp

RUN 	apk update
RUN		apk add --no-cache mysql mysql-client openrc

RUN		mkdir -p /run/mysqld; \
		mkdir -p /run/openrc; \
		touch /run/openrc/softlevel;

EXPOSE	3306

CMD		\
		sh /tmp/setup.sh;
