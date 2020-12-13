FROM alpine:latest

ADD ./srcs /tmp

RUN 	apk update
RUN	apk add php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom wget
RUN	apk add php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype
RUN	apk add --no-cache vim nginx openrc

RUN	mkdir -p /run/nginx; \
	mkdir -p /run/php-fpm7; \
	adduser -D -g 'www' www; \
	mkdir /run/openrc; \
	touch /run/openrc/softlevel; \
	mkdir /www; \
	chown -R www:www /var/lib/nginx;\
	chown -R www:www /www; \
	mv /tmp/nginx.conf /etc/nginx/nginx.conf; \
	mv /tmp/index.html /www/index.html; \
	cd www; \
	wget http://wordpress.org/latest.tar.gz; \
	tar -xzvf latest.tar.gz; \
	rm latest.tar.gz; \
	rc-status --manual;\
	rc-status --crashed; \
	mv /tmp/wp-config.php /www/wordpress/;

EXPOSE 5050

CMD 	\
		sh /tmp/script.sh;
