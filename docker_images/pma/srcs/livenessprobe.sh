#!/bin/ash
service nginx status
return_nginx=$?
service php-fpm7 status
return_php=$?
if [ "$return_nginx" = "0" ] && [ "$return_php" = "0" ]; then
	exit 0
else
	exit 1
fi
