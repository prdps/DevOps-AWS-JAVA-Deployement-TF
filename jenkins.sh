#!/bin/bash
apt update -y
apt upgrade -y
apt update
apt install fontconfig openjdk-21-jre -y
java -version
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update -y
apt install jenkins -y