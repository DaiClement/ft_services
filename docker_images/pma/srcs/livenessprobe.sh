#!/bin/ash
service nginx status
return_nginx=$?

return_php=`ps | grep 'master process (/etc/php7/php-fpm.conf)' | wc -l`
if [ "$return_nginx" = "0" ] && [ "$return_php" = "2" ]; then
	exit 0
else
	echo $return_php
	exit 1
fi
