#!/bin/ash
curl --ftp-ssl --insecure --user root:pass ftp://localhost:21
return_ftps="$?"
if [ "$return_ftps" = "0" ]; then
	exit 0
else
	exit 1
fi
