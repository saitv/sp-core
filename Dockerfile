FROM openjdk:8-jre-slim

#################################################################
# Install java
#################################################################
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    TZ=Europe/Copenhagen \
    WORKDIR=/usr/app/ \
    USER=appuser

# hadolint ignore=DL3008
RUN set -eu; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        software-properties-common  \
        tzdata \
        curl; \
    rm -rf /var/lib/apt/lists/*; \
    \
    cp /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime; \
    echo "Europe/Copenhagen" > /etc/timezone; \
    useradd -u 1000 -U -d "${WORKDIR}" "${USER}"
  

#################################################################
# Install maven
#################################################################

ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="${WORKDIR}"
ARG BASE_URL=https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/
ARG SHA=22cac91b3557586bb1eba326f2f7727543ff15e3

RUN curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz 
RUN echo "${SHA}  /tmp/apache-maven.tar.gz" | sha1sum -c - 
## Verified, let's install 
RUN mkdir -p /usr/share/maven /usr/share/maven/ref 
RUN tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 
RUN rm -f /tmp/apache-maven.tar.gz 
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
