FROM oraclelinux:8.5

RUN dnf install -q -y tar java gettext openssl librdkafka

RUN useradd kafka -m
RUN usermod -aG wheel kafka

COPY ./kafka*.tgz  /tmp/
RUN tar -C /opt -xzf /tmp/*.tgz
RUN mv /opt/kafka_*/ /opt/kafka/
COPY ./config/server.properties.template /opt/kafka/config/
RUN rm -f /etc/rc3.d/*
COPY ./rc/* /etc/rc3.d/
COPY bootstrap /
CMD /bootstrap
