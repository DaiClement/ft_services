#!/bin/ash
service nginx status
return_nginx=$?
netstat -an | grep :9000
return_php=$?
if [ "$return_nginx" = "0" ] && [ "$return_php" = "0" ]; then
	exit 0
else
	echo $return_php
	exit 1
fi
