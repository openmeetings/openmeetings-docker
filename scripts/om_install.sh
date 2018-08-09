# #############################################
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# #############################################

if [ ! -d "/var/run/mysqld" ]; then
	mkdir /var/run/mysqld
fi

sudo chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && service mysql start

mysql -u root -p${DB_ROOT_PASS} -se "CREATE DATABASE ${OM_DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"
mysql -u root -p${DB_ROOT_PASS} -se "CREATE USER '${OM_DB_USER}'@'localhost' IDENTIFIED BY '${OM_DB_PASS}'"
mysql -u root -p${DB_ROOT_PASS} -se "grant all privileges on ${OM_DB_NAME}.* to '${OM_DB_USER}'@'localhost'"

sudo chown -R nobody:nogroup ${OM_HOME}
sudo -u nobody ./admin.sh -v -i -tz Europe/Berlin -email kulkarnidhana22@gmail.com -group group \
	-user ${OM_USER} --password ${OM_PASS} \
	--db-type mysql --db-host localhost --db-name ${OM_DB_NAME} \
	--db-user ${OM_DB_USER} --db-pass ${OM_DB_PASS}


