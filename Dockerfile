FROM ubuntu:16.04
MAINTAINER Apache OpenMeetings dev team version: 3.1.3

RUN cat /etc/issue

RUN apt update
RUN apt install -y --no-install-recommends apt-utils
RUN apt update && apt install -y software-properties-common imagemagick unzip make build-essential wget sox

RUN add-apt-repository -y ppa:webupd8team/java && apt update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
RUN apt install -y oracle-java8-installer

RUN apt install -y libreoffice --no-install-recommends

CMD ["echo", "OK"]


