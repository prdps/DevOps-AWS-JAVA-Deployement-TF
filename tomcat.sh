#!/bin/bash
apt update -y
apt upgrade -y
apt install openjdk-21-jre -y
wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.21/bin/apache-tomcat-11.0.21.tar.gz
tar -xvf apache-tomcat-11.0.21.tar.gz
mv apache-tomcat-11.0.21 /opt/tomcat
cd /opt/tomcat/bin
chmod +x *.sh
./startup.sh