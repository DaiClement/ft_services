FROM	alpine:latest

ADD		./srcs /tmp

RUN 	apk update
RUN		apk add --no-cache vsftpd
RUN		apk add --no-cache openrc
RUN		apk add --no-cache openssl
RUN		apk add --no-cache curl

RUN		\
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
		echo root:pass | chpasswd; \
		/etc/init.d/vsftpd restart;

EXPOSE	20 21

CMD		\
		rc-service vsftpd restart; \
		tail -f /dev/null;
