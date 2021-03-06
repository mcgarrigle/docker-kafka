FROM centos:7

RUN rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7
RUN yum install -q -y epel-release
RUN yum install -q -y java gettext iproute

RUN useradd kafka -m
RUN usermod -aG wheel kafka

COPY ./*.tgz  /tmp
RUN tar -C /opt -xzf /tmp/*.tgz
RUN mv /opt/kafka_*/ /opt/kafka/
RUN echo -e "\ndelete.topic.enable = true" >> "/opt/kafka/config/server.properties"
COPY ./config/server.properties.template /opt/kafka/config/

RUN rm -f /etc/rc3.d/*
COPY ./rc/* /etc/rc3.d/
COPY bootstrap /
CMD /bootstrap
