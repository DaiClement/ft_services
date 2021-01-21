FROM alpine:latest

ADD ./srcs /tmp

RUN 	apk update
RUN	apk add --no-cache vim
RUN	apk add libc6-compat
RUN 	apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata; \
	update-ca-certificates;

RUN	mkdir ~/.gnupg;
RUN    	apk add --no-cache --virtual .build-deps wget gnupg tar 

RUN	\
	wget https://dl.influxdata.com/influxdb/releases/influxdb-1.8.3-static_linux_amd64.tar.gz

RUN	addgroup influxdb && \
	adduser -s /bin/false -G influxdb -S -D influxdb;

RUN	tar -C . -xzf influxdb-1.8.3-static_linux_amd64.tar.gz;
#	mkdir /etc/influxdb; \
RUN     chmod +x influxdb-*/*; \
        cp -a influxdb-*/* /usr/bin/; \
	mkdir -p /var/lib/influxdb/data; \
	chown -R influxdb:influxdb /var/lib/influxdb/data; \
	mkdir -p /etc/influxdb/; \
	cp /influxdb-*/influxdb.conf /etc/influxdb/;

RUN	mkdir -p /usr/src /etc/telegraf; \
	wget https://dl.influxdata.com/telegraf/releases/telegraf-1.16.2_linux_amd64.tar.gz; \
	tar -C /usr/src -xzf telegraf-1.16.2_linux_amd64.tar.gz; \
    	mv /usr/src/telegraf*/etc/telegraf/telegraf.conf /etc/telegraf/; \
    	mkdir /etc/telegraf/telegraf.d; \
    	cp -a /usr/src/telegraf*/usr/bin/telegraf /usr/bin/; \
	cp /tmp/telegraf.conf /etc/telegraf/;
#	echo 'create database grafana' | influx;
#	echo "CREATE USER 'admin' WITH PASSWORD 'admin' WITH ALL PRIVILEGES" | influx;

EXPOSE	8086

CMD	\
	influxd & telegraf;
