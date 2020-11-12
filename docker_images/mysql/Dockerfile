FROM alpine:latest

ADD ./srcs /srcs

RUN 	apk update
RUN	apk add vim
RUN	apk add mysql mysql-client

RUN	mkdir -p /run/mysqld
RUN	mv srcs/my.cnf /etc/

EXPOSE 3306

CMD	/usr/bin/mysql_install_db --datadir=/var/lib/mysql; \
	/usr/bin/mysqld --init_file=/srcs/init_file & sleep 3; \
	/usr/bin/mysqladmin -u root password 'pass'; \
	tail -f /dev/null
