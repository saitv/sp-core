FROM  ubuntu:18.04

#################################################################
# Install java
#################################################################
ENV DEBIAN_FRONTEND noninteractive 
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && \
    apt-get install -y software-properties-common  \
    git \
    iputils-ping \
    tzdata \
    curl && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN  cp /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime \
    && echo "Europe/Copenhagen" > /etc/timezone

ENV TZ Europe/Copenhagen

#################################################################
# Install maven
#################################################################

ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/
ARG SHA=22cac91b3557586bb1eba326f2f7727543ff15e3

RUN curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz 
RUN echo "${SHA}  /tmp/apache-maven.tar.gz" | sha1sum -c - 
## Verified, let's install 
RUN mkdir -p /usr/share/maven /usr/share/maven/ref 
RUN tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 
RUN rm -f /tmp/apache-maven.tar.gz 
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
