# Use an official Python runtime as a parent image
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update && apt-get install -y --no-install-recommends software-properties-common && add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections) && \
    apt-get install --no-install-recommends -y oracle-java8-installer && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    echo "networkaddress.cache.ttl=60" >> /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
