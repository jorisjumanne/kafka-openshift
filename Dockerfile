FROM rhel
ENV ENABLE_AUTO_EXTEND true
RUN mkdir -p /opt/kafka \
  && cd /opt/kafka \
  && ln -s /var/run/secrets/rhel7.repo /etc/yum.repos.d/rhel7.repo \
  && yum -y install java-1.8.0-openjdk-headless tar \
  && curl -s http://www.mirrorservice.org/sites/ftp.apache.org/kafka/0.10.1.0/kafka_2.11-0.10.1.0.tgz | tar -xz --strip-components=1 \
  && yum -y remove tar \
  && yum clean all \
  && rm /etc/yum.repos.d/rhel7.repo
COPY bin/*.sh /opt/kafka/bin/
COPY lib/*.jar /opt/kafka/libs/
COPY config/* /opt/kafka/config/
RUN chmod -R a=u /opt/kafka
RUN chmod -R a+rx /opt/kafka/bin/*
WORKDIR /opt/kafka
VOLUME /tmp/kafka-logs /tmp/zookeeper
EXPOSE 2181 2888 3888 9092
