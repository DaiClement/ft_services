FROM alpine:latest

ADD ./srcs /srcs

RUN 	apk update
RUN	apk add php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype
RUN	apk add --no-cache tzdata phpmyadmin nginx openrc

RUN	\
	mkdir -p /run/nginx; \
	mkdir -p /run/php-fpm7; \
	mkdir /run/openrc; \
	touch /run/openrc/softlevel; \
	adduser -D -g 'www' www; \
	mkdir /www; \
	chown -R www:www /var/lib/nginx;\
	chown -R www:www /www; \
	mv /srcs/nginx.conf /etc/nginx/nginx.conf; \
	mv /srcs/index.html /www/index.html; \
	chmod -R 777 /usr/share/webapps/; \
	chown -R www:www /etc/phpmyadmin;\
	ln -s /usr/share/webapps/phpmyadmin /www/phpmyadmin; \
	rc-status --manual; \
	rc-status --crashed; \
	mv /srcs/config.inc.php /www/phpmyadmin;


EXPOSE 5000


CMD 	\
	sed -i 's/mysql-alpine/'$MYSQL_SERVICE_PORT_3306_TCP_ADDR':3306/g' /www/phpmyadmin/config.inc.php; \
	rc-service php-fpm7 start; \
	rc-service nginx start; \
	tail -f /dev/null;
