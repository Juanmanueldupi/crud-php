#! /bin/sh

while ! mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST}  -e ";" ; do
        sleep 1
done
mysql -u $DB_USER --password=$DB_PASSWORD -h $DB_HOST $DB_NAME < /opt/database.sql
/usr/sbin/apache2ctl -D FOREGROUND
