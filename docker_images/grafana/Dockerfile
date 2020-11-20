FROM	alpine:latest

ADD	./srcs /tmp

ENV	PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin 

WORKDIR	/usr/share/grafana

RUN 	apk update
RUN	apk add --no-cache vim
RUN	apk add --no-cache bash
RUN	apk add --no-cache libc6-compat
RUN	apk add --no-cache ca-certificates

run	wget https://dl.grafana.com/oss/release/grafana-7.3.2.linux-amd64.tar.gz; \
	tar -zxvf grafana-7.3.2.linux-amd64.tar.gz; \
	cp -r grafana-7.3.2/* .; \
    	addgroup -S grafana; \
    	adduser -S -G grafana grafana; \
	cp /tmp/datasource.yaml /usr/share/grafana/conf/provisioning/datasources/; \
	cp /tmp/test.yaml /usr/share/grafana/conf/provisioning/dashboards/; \
	cp /tmp/*.json /usr/share/grafana/conf/provisioning/dashboards/;

#RUN	mkdir -p /usr/src /etc/telegraf; \
#	wget https://dl.influxdata.com/telegraf/releases/telegraf-1.16.2_linux_amd64.tar.gz; \
#	tar -C /usr/src -xzf telegraf-1.16.2_linux_amd64.tar.gz; \
#    	mv /usr/src/telegraf*/etc/telegraf/telegraf.conf /etc/telegraf/; \
#    	mkdir /etc/telegraf/telegraf.d; \
#    	cp -a /usr/src/telegraf*/usr/bin/telegraf /usr/bin/; \
#	cp /tmp/telegraf.conf /etc/telegraf/;

EXPOSE	3000

CMD \
	grafana-server \
	--homepath=/usr/share/grafana \
	--config=/tmp/grafana.ini \
	--packaging=docker \
	"$@"
#	& telegraf;
