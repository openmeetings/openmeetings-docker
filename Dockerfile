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
ENV OM_VER_MAJ '4'
ENV OM_VER_MIN '0'
ENV OM_VER_MIC '8'
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
ENV OM_HOME /opt/red5
ENV MYSQL_J_VER '8.0.15'

RUN cat /etc/issue \
 && echo "mysql-server mysql-server/root_password password ${DB_ROOT_PASS}" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again password ${DB_ROOT_PASS}" | debconf-set-selections \
    && echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | debconf-set-selections \
    && echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  \
  && apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common \
  && add-apt-repository -y ppa:webupd8team/java && apt-get update \
  && apt-get install -y --no-install-recommends \
    unzip \
    wget \
    ghostscript \
    libgs-dev \
    imagemagick \
    sox \
    sudo \
    libreoffice \
    oracle-java8-installer \
    mysql-server \
    mysql-client \
    ffmpeg \
  && rm -rf /var/lib/apt/lists/*

WORKDIR ${work}
COPY scripts/*.sh ./
RUN chmod a+x *.sh

WORKDIR ${OM_HOME}
RUN wget "https://archive.apache.org/dist/openmeetings/${OM_VERSION}/bin/apache-openmeetings-${OM_VERSION}.tar.gz" -O om.tar.gz \
    && wget "https://archive.apache.org/dist/openmeetings/${OM_VERSION}/bin/apache-openmeetings-${OM_VERSION}.tar.gz.asc" -O om.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys C467526E \
    && gpg --batch --verify om.asc om.tar.gz \
    && tar -xzf om.tar.gz \
    && rm -rf ${GNUPGHOME} om.asc om.tar.gz \
    && wget "https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_J_VER}/mysql-connector-java-${MYSQL_J_VER}.jar" -P webapps/openmeetings/WEB-INF/lib \
    && chmod a+x *.sh \
    && ${work}/om_install.sh \
    && sed -i 's|<policy domain="coder" rights="none" pattern="PS" />|<!--policy domain="coder" rights="none" pattern="PS" />|g; s|<policy domain="coder" rights="none" pattern="XPS" />|<policy domain="coder" rights="none" pattern="XPS" /-->|g' /etc/ImageMagick-6/policy.xml

EXPOSE 5080 1935
#CMD bash ${work}/om.sh

ENTRYPOINT [ "bash", "-c", "${work}/om.sh" ]

