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
if [[ `id -u ${DAEMON_USER} 2>/dev/null || echo -1` < 0 ]]; then
	useradd -l -u ${DAEMON_UID} ${DAEMON_USER}
fi
if [ ! -d "${OM_HOME}/logs" ]; then
	mkdir ${OM_HOME}/logs
fi
chown -R ${DAEMON_USER} ${OM_HOME}

if [ "${OM_TYPE}" != "min" ]; then
	if [ ! -d "/var/run/mysqld" ]; then
		mkdir /var/run/mysqld
	fi

	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && service mysql restart
fi

