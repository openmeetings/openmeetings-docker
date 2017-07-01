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
MAINTAINER Apache OpenMeetings dev team version: 3.2.1 <dev@openmeetings.apache.org>

ENV OM_VER_MAJ '3'
ENV OM_VER_MIN '2'
ENV OM_VER_MIC '1'
ENV OM_VERSION "${OM_VER_MAJ}.${OM_VER_MIN}.${OM_VER_MIC}"
ENV DB_ROOT_PASS '12345'
ENV OM_DB_NAME "open${OM_VER_MAJ}_${OM_VER_MIN}_${OM_VER_MIC}"
ENV OM_DB_USER 'om_admin'
ENV OM_DB_PASS '12345'
ENV OM_USER 'om_admin'
ENV OM_PASS '12345'
ENV work /root/work
ENV OM_HOME /opt/red5

RUN cat /etc/issue

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends software-properties-common unzip make build-essential wget ghostscript libgs-dev imagemagick sox sudo

RUN add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | debconf-set-selections
RUN echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections
RUN apt-get install -y oracle-java8-installer

RUN apt-get install -y libreoffice --no-install-recommends

WORKDIR ${work}
RUN wget https://launchpad.net/ella-renaissance/ella-renaissance-beta/beta1/+download/swftools_0.9.1-1_amd64.deb
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/libo/liboil/liboil0.3_0.3.17-2ubuntu4_amd64.deb
RUN apt-get install -y libgstreamer-plugins-base0.10-0 libgstreamer0.10-0 libgtk2.0-0 libpango1.0-0 libjpeg62
RUN dpkg -i swftools_0.9.1-1_amd64.deb liboil0.3_0.3.17-2ubuntu4_amd64.deb

#put swf tools on hold
RUN echo "swftools hold" | dpkg --set-selections

WORKDIR ${work}
COPY scripts/* ./
RUN chmod a+x *.sh
RUN ./ffmpeg-ubuntu-debian.sh

RUN echo "mysql-server mysql-server/root_password password ${DB_ROOT_PASS}" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password ${DB_ROOT_PASS}" | debconf-set-selections
RUN apt-get -y install mysql-server mysql-client

WORKDIR ${work}
RUN wget http://www-eu.apache.org/dist/openmeetings/${OM_VERSION}/bin/apache-openmeetings-${OM_VERSION}.tar.gz

WORKDIR ${OM_HOME}
RUN tar -xzf ${work}/apache-openmeetings-${OM_VERSION}.tar.gz
RUN wget http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar -P webapps/openmeetings/WEB-INF/lib

RUN ${work}/om_install.sh

EXPOSE 5080 1935
CMD bash ${work}/om.sh

