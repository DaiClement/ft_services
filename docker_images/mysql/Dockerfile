FROM alpine:latest

ADD ./srcs /tmp

RUN 	apk update
RUN	apk add --no-cache mysql mysql-client openrc

RUN	mkdir -p /run/mysqld; \
	mkdir -p /run/openrc; \
	touch /run/openrc/softlevel;
RUN	mv tmp/my.cnf /etc/; \
	/usr/bin/mysql_install_db --datadir=/var/lib/mysql; \
	rc-status --manual; \
	rc-status --crashed; \
	rc-service mariadb start; \
	echo "CREATE USER 'cdai'@'%' IDENTIFIED BY 'pass';" | mysql; \
	echo "GRANT ALL ON *.* TO 'cdai'@'%' WITH GRANT OPTION;" | mysql; \
	echo "CREATE DATABASE wordpress;" | mysql; \
	echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-admin'@'%' IDENTIFIED BY 'pass';" | mysql; \
	echo "FLUSH PRIVILEGES;" | mysql;
	

EXPOSE 3306

CMD	\
	rc-service mariadb restart; \
	tail -f /dev/null;
