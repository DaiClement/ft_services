FROM alpine:latest

ADD ./srcs /tmp

RUN 	apk update
RUN	apk add --no-cache vim
RUN	apk add --no-cache nginx

RUN	adduser -D -g 'www' www; \
	mkdir /www; \
	mkdir -p /run/nginx; \
	mv tmp/nginx.conf /etc/nginx/nginx.conf; \
	mv tmp/index.html /www/index.html;

EXPOSE	3000

#CMD \
#	nginx -g "daemon off;"
