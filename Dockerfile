FROM centos:7

RUN rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7
RUN yum install -q -y epel-release
RUN yum install -q -y java

RUN useradd kafka -m
RUN usermod -aG wheel kafka

COPY ./*.tgz  /tmp
RUN tar -C /opt -xzf /tmp/*.tgz
RUN mv /opt/kafka_*/ /opt/kafka/
RUN echo -e "\ndelete.topic.enable = true" >> "/opt/kafka/config/server.properties"

RUN rm -f /etc/rc3.d/*
COPY ./rc/* /etc/rc3.d/
COPY bootstrap /
CMD /bootstrap

EXPOSE 2181
EXPOSE 9092
