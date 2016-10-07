FROM ubuntu:16.04
MAINTAINER Apache OpenMeetings dev team version: 3.1.3 <dev@openmeetings.apache.org>

ENV DB_ROOT_PASS '12345'
ENV OM_DB_NAME 'open313'
ENV OM_DB_USER 'om_admin'
ENV OM_DB_PASS '12345'
ENV OM_USER 'admin'
ENV OM_PASS '12345'
ENV work /root/work

RUN cat /etc/issue

RUN apt update
RUN apt install -y --no-install-recommends apt-utils
RUN apt update && apt install -y software-properties-common imagemagick unzip make build-essential wget sox sudo

RUN add-apt-repository -y ppa:webupd8team/java && apt update
RUN echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | debconf-set-selections
RUN echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections
RUN apt install -y oracle-java8-installer

RUN apt install -y libreoffice --no-install-recommends

WORKDIR ${work}
RUN wget https://launchpad.net/ella-renaissance/ella-renaissance-beta/beta1/+download/swftools_0.9.1-1_amd64.deb
RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/libo/liboil/liboil0.3_0.3.17-2ubuntu4_amd64.deb
RUN apt install -y libgstreamer-plugins-base0.10-0 libgstreamer0.10-0 libgtk2.0-0 libpango1.0-0
RUN dpkg -i swftools_0.9.1-1_amd64.deb liboil0.3_0.3.17-2ubuntu4_amd64.deb

#put swf tools on hold
RUN echo "swftools hold" | dpkg --set-selections

WORKDIR /opt
RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jodconverter/jodconverter-core-3.0-beta-4-dist.zip
RUN unzip jodconverter-core-3.0-beta-4-dist.zip
RUN ln -nfs /opt/jodconverter-core-3.0-beta-4 jod

ADD scripts/ffmpeg-ubuntu-debian.sh ${work}
ADD scripts/om_install.sh ${work}
ADD scripts/om.sh ${work}
WORKDIR ${work}
RUN chmod a+x ffmpeg-ubuntu-debian.sh om.sh
RUN ./ffmpeg-ubuntu-debian.sh

RUN echo "mysql-server mysql-server/root_password password ${DB_ROOT_PASS}" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password ${DB_ROOT_PASS}" | debconf-set-selections
RUN apt -y install mysql-server mysql-client

WORKDIR ${work}
RUN wget http://www-eu.apache.org/dist/openmeetings/3.1.3/bin/apache-openmeetings-3.1.3.tar.gz

WORKDIR /opt/red5
RUN tar -xzf /root/work/apache-openmeetings-3.1.3.tar.gz
RUN wget http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar -P webapps/openmeetings/WEB-INF/lib

WORKDIR ${work}
RUN ./om_install.sh

EXPOSE 5080 1935
CMD ["/bin/bash", "/root/work/om.sh"]

