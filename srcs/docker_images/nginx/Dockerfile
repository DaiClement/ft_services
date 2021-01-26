FROM	alpine:latest

ADD		./srcs /tmp

RUN 	apk update
RUN		apk add --no-cache nginx openssl openrc openssh

RUN		adduser -D -g 'www' www; \
		adduser -D user42; \
		echo "user42:user42" | chpasswd; \
		mkdir /www; \
		mkdir -p /run/nginx; \
		mkdir -p /run/sshd; \
		mkdir -p /run/openrc/softlevel; \
		mv tmp/nginx.conf /etc/nginx/nginx.conf; \
		mv tmp/index.html /www/index.html; \
		mv tmp/proxy_params /etc/nginx/proxy_params; \
		rc-status --manual;\
		rc-status --crashed; \
		openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -addext "subjectAltName=DNS:mydomain.com" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt;

EXPOSE	80 443 22

CMD		\
		rc-service nginx start; \
		rc-service sshd start; \
		tail -f /dev/null;
