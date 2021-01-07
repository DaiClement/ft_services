mv tmp/my.cnf /etc/;
/usr/bin/mysql_install_db --datadir=/var/lib/mysql;
rc-status --manual;
rc-status --crashed;
rc-service mariadb start;
if [ ! -d "/var/lib/mysql/wordpress" ]; then
echo "CREATE USER 'cdai'@'%' IDENTIFIED BY 'pass';" | mysql;
echo "GRANT ALL ON *.* TO 'cdai'@'%' WITH GRANT OPTION;" | mysql;
echo "CREATE DATABASE wordpress;" | mysql;
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-admin'@'%' IDENTIFIED BY 'pass';" | mysql;
echo "FLUSH PRIVILEGES;" | mysql;
fi
tail -f /dev/null;
