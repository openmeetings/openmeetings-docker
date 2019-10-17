#!/bin/bash
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

echo "OM server of type ${OM_TYPE} will be set-up"
if [ "${OM_TYPE}" != "min" ]; then

	apt-get update
	apt-get install -y --no-install-recommends gnupg2 dirmngr
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5AFA7A83

	KURENTO_LIST="/etc/apt/sources.list.d/kurento.list"
	echo "# Kurento Media Server" > ${KURENTO_LIST}
	echo "deb [arch=amd64] http://ubuntu.openvidu.io/6.12.0 bionic kms6" >> ${KURENTO_LIST}

	echo "mysql-server mysql-server/root_password password ${DB_ROOT_PASS}" | debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password ${DB_ROOT_PASS}" | debconf-set-selections
	echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

	apt-get update
	apt-get install -y --no-install-recommends \
		kurento-media-server \
		mysql-server \
		mysql-client
	apt-get clean
	rm -rf /var/lib/apt/lists/*
	sed -i "s/DAEMON_USER=\"kurento\"/DAEMON_USER=\"${DAEMON_USER}\"/g" /etc/default/kurento-media-server

	. ${work}/om_euser.sh

	mysql -u root -p${DB_ROOT_PASS} -se "CREATE DATABASE ${OM_DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"
	mysql -u root -p${DB_ROOT_PASS} -se "CREATE USER '${OM_DB_USER}'@'localhost' IDENTIFIED BY '${OM_DB_PASS}'"
	mysql -u root -p${DB_ROOT_PASS} -se "grant all privileges on ${OM_DB_NAME}.* to '${OM_DB_USER}'@'localhost'"

	cd ${OM_HOME}
	pwd
	ls -la
	sudo -u ${DAEMON_USER} ./admin.sh -v -i -tz Europe/Berlin -email your.email@gmail.com -group group \
		-user ${OM_USER} --password ${OM_PASS} \
		--db-type mysql --db-host localhost --db-name ${OM_DB_NAME} \
		--db-user ${OM_DB_USER} --db-pass ${OM_DB_PASS}
fi

