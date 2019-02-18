#!/bin/sh -ex

NEXUS="https://app.camunda.com/nexus/service/local/artifact/maven/redirect"

# DISTRO=tomcat
# REPO="camunda-bpm"
# ARTIFACT="camunda-bpm-tomcat"
ARTIFACT_VERSION="${VERSION}"
# GROUP="tomcat"
# ARTIFACT_GROUP="org.camunda.bpm.tomcat"

# Download distro from nexus
wget --progress=bar:force:noscroll -O /tmp/camunda.tar.gz "${NEXUS}?r=camunda-bpm&g=org.camunda.bpm.tomcat&a=camunda-bpm-tomcat&v=${ARTIFACT_VERSION}&p=tar.gz"

# Unpack distro to /camunda directory
mkdir -p /camunda
tar xzf /tmp/camunda.tar.gz -C /camunda server --strip 2

cp /tmp/camunda-tomcat.sh /camunda/camunda.sh

# download and register mysql database driver
wget --progress=bar:force:noscroll -O /tmp/pom.xml "${NEXUS}?r=camunda-bpm&g=org.camunda.bpm&a=camunda-database-settings&v=${ARTIFACT_VERSION}&p=pom"
MYSQL_VERSION=$(xmlstarlet sel -t -v //_:version.mysql /tmp/pom.xml)

wget -O /tmp/mysql-connector-java-${MYSQL_VERSION}.jar "${NEXUS}?r=public&g=mysql&a=mysql-connector-java&v=${MYSQL_VERSION}&p=jar"
cp /tmp/mysql-connector-java-${MYSQL_VERSION}.jar /camunda/lib
echo "" > /camunda/bin/setenv.sh

