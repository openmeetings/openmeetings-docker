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

FROM ubuntu:16.04
ENV OM_VER_MAJ '5'
ENV OM_VER_MIN '0'
ENV OM_VER_MIC '0'
ENV OM_VERSION "${OM_VER_MAJ}.${OM_VER_MIN}.${OM_VER_MIC}"
LABEL vendor="Apache OpenMeetings dev team"
LABEL version="${OM_VERSION}"
LABEL maintainer=dev@openmeetings.apache.org

ENV DB_ROOT_PASS '12345'
ENV OM_DB_NAME "open${OM_VER_MAJ}_${OM_VER_MIN}_${OM_VER_MIC}"
ENV OM_DB_USER 'om_admin'
ENV OM_DB_PASS '12345'
ENV OM_USER 'om_admin'
ENV OM_PASS '1Q2w3e4r5t^y'
ENV work /root/work
ENV OM_HOME /opt/openmeetings
ENV MYSQL_J_VER '8.0.15'
ENV KURENTO_LIST "/etc/apt/sources.list.d/kurento.list"

RUN cat /etc/issue

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends software-properties-common unzip make build-essential wget ghostscript libgs-dev imagemagick sox sudo

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83
RUN echo "" > ${KURENTO_LIST}
RUN echo "# Kurento Media Server - Release packages" >> ${KURENTO_LIST}
RUN echo "deb [arch=amd64] http://ubuntu.openvidu.io/6.9.0 xenial kms6" >> ${KURENTO_LIST}

RUN apt-get install -y openjdk-8-jdk kurento-media-server

RUN apt-get install -y libreoffice --no-install-recommends

WORKDIR ${work}
COPY scripts/*.sh ./
RUN chmod a+x *.sh

RUN echo "mysql-server mysql-server/root_password password ${DB_ROOT_PASS}" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password ${DB_ROOT_PASS}" | debconf-set-selections
RUN apt-get -y install mysql-server mysql-client ffmpeg

WORKDIR ${work}
#RUN wget http://www-eu.apache.org/dist/openmeetings/${OM_VERSION}/bin/apache-openmeetings-${OM_VERSION}.tar.gz
RUN wget https://builds.apache.org/view/M-R/view/OpenMeetings/job/openmeetings/lastSuccessfulBuild/artifact/openmeetings-server/target/apache-openmeetings-5.0.0-SNAPSHOT.tar.gz -O apache-openmeetings-${OM_VERSION}.tar.gz

WORKDIR ${OM_HOME}
RUN tar -xzf ${work}/apache-openmeetings-${OM_VERSION}.tar.gz
RUN wget http://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_J_VER}/mysql-connector-java-${MYSQL_J_VER}.jar -P webapps/openmeetings/WEB-INF/lib

RUN ${work}/om_install.sh

RUN sed -i 's|<policy domain="coder" rights="none" pattern="PS" />|<!--policy domain="coder" rights="none" pattern="PS" />|g; s|<policy domain="coder" rights="none" pattern="XPS" />|<policy domain="coder" rights="none" pattern="XPS" /-->|g' /etc/ImageMagick-6/policy.xml

RUN sed -i 's/DAEMON_USER="kurento"/DAEMON_USER="nobody"/g' /etc/default/kurento-media-server

EXPOSE 5443 8888
#CMD bash ${work}/om.sh

ENTRYPOINT [ "bash", "-c", "${work}/om.sh" ]

