FROM centos:7.1.1503
MAINTAINER andras.szerdahelyi@gmail.com

# Install pre-requisite packages..
RUN yum -y install java-1.8.0-openjdk-devel-1.8.0.60-2.b27.el7_1 \
	jna-3.5.2 \
	python-2.7.5-18.el7_1.1 \
	python-setuptools-0.9.8 \
	tar \
	gzip
	
ADD http://mirror.catn.com/pub/apache/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz /opt/
ADD https://pypi.python.org/packages/source/p/pip/pip-7.1.0.tar.gz#md5=d935ee9146074b1d3f26c5f0acfd120e /root/

ADD etc/supervisord.conf /etc/supervisord.conf
RUN cd /root && easy_install pip-7.1.0.tar.gz
RUN pip install supervisor
RUN cd /opt && tar xfv hadoop-2.7.0.tar.gz && rm hadoop-2.7.0.tar.gz

RUN useradd hadoop \
	&& ln -s /opt/hadoop-2.7.0 /home/hadoop/hadoop-2.7.0 \
	&& ln -s /opt/hadoop-2.7.0/etc/hadoop /etc/hadoop \
	&& chown -R hadoop:hadoop /opt/hadoop-2.7.0

ADD etc/hadoop/core-site.xml.erb /etc/hadoop/core-site.xml.erb

ENV HADOOP_LOG_DIR="/var/log/hadoop"
ENV HADOOP_ROOT_LOGGER="WARN,RFA"
ENV YARN_LOG_DIR=$HADOOP_LOG_DIR
ENV YARN_ROOT_LOGGER=$HADOOP_ROOT_LOGGER

RUN mkdir -p $HADOOP_LOG_DIR
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/supervisor

RUN chown hadoop $HADOOP_LOG_DIR
RUN chown hadoop /var/log/supervisor
RUN chown hadoop /var/run/supervisor

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk
ENV PATH $PATH:/opt/hadoop-2.7.0/bin
