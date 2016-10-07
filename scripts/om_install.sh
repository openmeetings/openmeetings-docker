service mysql start

mysql -u root -p${DB_ROOT_PASS} -se "CREATE DATABASE ${OM_DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"
mysql -u root -p${DB_ROOT_PASS} -se "CREATE USER '${OM_DB_USER}'@'localhost' IDENTIFIED BY '${OM_DB_PASS}'"
mysql -u root -p${DB_ROOT_PASS} -se "grant all privileges on ${OM_DB_NAME}.* to '${OM_DB_USER}'@'localhost'"

cd /opt/red5
chown -R nobody:nogroup /opt/red5
sudo -u nobody ./admin.sh -v -i -tz Europe/Berlin -email your.email@gmail.com -group group \
	-user ${OM_USER} --password ${OM_PASS} \
	--db-type mysql --db-host localhost --db-name ${OM_DB_NAME} \
	--db-user ${OM_DB_USER} --db-pass ${OM_DB_PASS}


