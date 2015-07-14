FROM centos:7.1.1503
MAINTAINER andras.szerdahelyi@gmail.com

RUN yum -y update && yum clean all

# Install pre-requisite packages..
RUN yum -y install \
	java-1.8.0-openjdk-devel-1.8.0.45-30.b13.el7_1 \
	jna-3.5.2 \
	python-2.7.5-18.el7_1.1 \
	python-setuptools-0.9.8 \
	tar \
	gzip
	
ADD http://mirror.catn.com/pub/apache/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz /opt/
ADD https://pypi.python.org/packages/source/p/pip/pip-7.1.0.tar.gz#md5=d935ee9146074b1d3f26c5f0acfd120e /root/

RUN cd /root && easy_install pip-7.1.0.tar.gz
RUN pip install supervisor
RUN cd /opt && tar xfv hadoop-2.7.0.tar.gz && rm hadoop-2.7.0.tar.gz

RUN useradd hadoop \
	&& ln -s /opt/hadoop-2.7.0 /home/hadoop/hadoop-2.7.0 \
	&& ln -s /opt/hadoop-2.7.0/etc/hadoop /etc/hadoop \
	&& chown -R hadoop:hadoop /opt/hadoop-2.7.0

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.45-30.b13.el7_1.x86_64/
ENV PATH $PATH:/opt/hadoop-2.7.0/bin
