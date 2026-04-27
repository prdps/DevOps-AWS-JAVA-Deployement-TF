#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker

docker volume create sonarqube_data
docker volume create sonarqube_extensions
docker volume create sonarqube_logs

docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  -v sonarqube_logs:/opt/sonarqube/logs \
  sonarqube:community