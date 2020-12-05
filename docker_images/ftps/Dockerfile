FROM alpine:latest

ADD ./srcs /tmp

RUN 	apk update
#RUN	apk add --no-cache nginx
RUN	apk add --no-cache vsftpd
RUN	apk add --no-cache openrc
RUN	apk add --no-cache vim
RUN	apk add --no-cache openssl

RUN	\
	openssl \
	req \
	-new \
	-x509 \
	-days 365 \
	-nodes \
	-subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" \
	-addext "subjectAltName=DNS:mydomain.com" \
	-newkey rsa:2048 \
	-out /etc/ssl/private/vsftpd.cert.pem \
	-keyout /etc/ssl/private/vsftpd.key.pem; \
	chown root:root /etc/ssl/private/vsftpd.cert.*; \
	chmod 600 /etc/ssl/private/vsftpd.cert.*; \
	mkdir -p /run/openrc; \
	touch /run/openrc/softlevel; \
	rc-status --manual; \
	rc-status --crashed; \
	cp /tmp/vsftpd.conf /etc/vsftpd/; \
	cp /tmp/chroot.list /etc/vsftpd/; \
	echo root:pass | chpasswd; \
	adduser -D user42 -g root; \
	echo user42:user42 | chpasswd; \
	/etc/init.d/vsftpd restart;
#	mkdir /www; \
#	adduser -D -g 'www' www; \
#	mv tmp/index.html /www/index.html; \
#	mkdir -p /run/nginx; \
#	mv tmp/nginx.conf /etc/nginx/nginx.conf; \
#	/etc/init.d/nginx restart; \
#	openssl \
#	req \
#	-x509 \
#	-nodes \
#	-days 365 \
#	-subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" \
#	-addext "subjectAltName=DNS:mydomain.com" \
#	-newkey rsa:2048 \
#	-keyout /etc/ssl/private/nginx-selfsigned.key \
#	-out /etc/ssl/certs/nginx-selfsigned.crt;




EXPOSE 21

#CMD \
#	nginx -g "daemon off;"
CMD	\
	rc-service vsftpd restart; \
	tail -f /dev/null;
#/etc/init.d/vsftpd restart
#
