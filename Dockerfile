FROM centos:7

RUN rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7
RUN yum install -q -y epel-release
RUN yum install -q -y java gettext iproute openssl

RUN useradd kafka -m
RUN usermod -aG wheel kafka

COPY ./*.tgz  /tmp
RUN tar -C /opt -xzf /tmp/*.tgz
RUN mv /opt/kafka_*/ /opt/kafka/
COPY ./config/server.properties.template /opt/kafka/config/
COPY ./self-signed-certificate.sh /usr/local/bin/
RUN rm -f /etc/rc3.d/*
COPY ./rc/* /etc/rc3.d/
COPY bootstrap /
CMD /bootstrap
