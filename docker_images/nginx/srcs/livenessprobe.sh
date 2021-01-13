#!/bin/ash
service nginx status
return_nginx="$?"
if [ "$return_nginx" = "0" ]; then
	exit 0
else
	exit 1
fi
