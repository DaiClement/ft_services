#!/bin/ash
influx -database 'influxdb_metrics_data' -execute 'select * from cpu' -format 'json' -pretty;
return_influx="$?"
#service sshd status
#return_sshd=$?
#if [ $return_nginx = 0 ] && [ $return_sshd = 0 ]; then
if [ "$return_influx" = "0" ]; then
	exit 0
else
	exit 1
fi
