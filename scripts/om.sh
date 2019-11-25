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

. ${work}/om_euser.sh
echo "OM server of type ${OM_TYPE} will be run"
if [ "${OM_TYPE}" == "min" ]; then
	CLASSES_HOME=${OM_HOME}/webapps/openmeetings/WEB-INF/classes
	DB_CFG_HOME=${CLASSES_HOME}/META-INF
	cp ${DB_CFG_HOME}/${OM_DB_TYPE}_persistence.xml ${DB_CFG_HOME}/persistence.xml
	case ${OM_DB_TYPE} in
		db2)
			sed -i "s|localhost:50000/openmeet|${OM_DB_HOST}:${OM_DB_PORT}/${OM_DB_NAME}|g" ${DB_CFG_HOME}/persistence.xml
		;;
		mssql)
			sed -i "s|localhost:1433;databaseName=openmeetings|${OM_DB_HOST}:${OM_DB_PORT};databaseName=${OM_DB_NAME}|g" ${DB_CFG_HOME}/persistence.xml
		;;
		mysql)
			sed -i "s|localhost:3306/openmeetings|${OM_DB_HOST}:${OM_DB_PORT}/${OM_DB_NAME}|g" ${DB_CFG_HOME}/persistence.xml
		;;
		postgresql)
			sed -i "s|localhost:5432/openmeetings|${OM_DB_HOST}:${OM_DB_PORT}/${OM_DB_NAME}|g" ${DB_CFG_HOME}/persistence.xml
		;;
	esac
	sed -i "s/Username=/Username=${OM_DB_USER}/g; s/Password=/Password=${OM_DB_PASS}/g" ${DB_CFG_HOME}/persistence.xml
	if [ ! -d "${OM_DATA_DIR}" ]; then
		mkdir "${OM_DATA_DIR}"
	fi
	sed -i "s|ws://127.0.0.1:8888/kurento|${OM_KURENTO_WS_URL}|g" ${CLASSES_HOME}/applicationContext.xml

	export CATALINA_OPTS="-DDATA_DIR=${OM_DATA_DIR}"
else
	service kurento-media-server start
fi
if [ -n "${TURN_URL}" ]; then
	sed -i "s|p:turnUrl=\"\"|p:turnUrl=\"${TURN_URL}\"|g" ${CLASSES_HOME}/applicationContext.xml
fi
if [ -n "${TURN_USER}" ]; then
	sed -i "s|p:turnUser=\"\"|p:turnUser=\"${TURN_USER}\"|g" ${CLASSES_HOME}/applicationContext.xml
fi
if [ -n "${TURN_PASS}" ]; then
	sed -i "s|p:turnSecret=\"\"|p:turnSecret=\"${TURN_PASS}\"|g" ${CLASSES_HOME}/applicationContext.xml
fi
cd ${OM_HOME}
sudo -u ${DAEMON_USER} ${OM_HOME}/bin/catalina.sh run

