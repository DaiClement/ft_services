FROM	alpine:latest

ADD	./srcs /tmp

ENV	PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin 

WORKDIR	/usr/share/grafana

RUN 	apk update
RUN	apk add --no-cache vim
RUN	apk add --no-cache bash
RUN	apk add --no-cache libc6-compat
RUN	apk add --no-cache ca-certificates


RUN 	apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata; \
	update-ca-certificates;

RUN	mkdir ~/.gnupg;
RUN    	apk add --no-cache --virtual .build-deps wget gnupg tar 


RUN	wget -q https://dl.grafana.com/oss/release/grafana-7.3.2.linux-amd64.tar.gz; \
	tar -zxf grafana-7.3.2.linux-amd64.tar.gz; \
	cp -r grafana-7.3.2/* .; \
    	addgroup -S grafana; \
    	adduser -S -G grafana grafana; \
	cp /tmp/dashboard.yaml /usr/share/grafana/conf/provisioning/dashboards/; \
	cp /tmp/*.json /usr/share/grafana/conf/provisioning/dashboards/;

EXPOSE	3000

CMD \
	sed -i 's/influxdb-alpine/'$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR'/g' /tmp/datasource.yaml; \
	cp /tmp/datasource.yaml /usr/share/grafana/conf/provisioning/datasources/; \
	grafana-server \
	--homepath=/usr/share/grafana \
	--config=/tmp/grafana.ini \
	--packaging=docker \
	"$@";
