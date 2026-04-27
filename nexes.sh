#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
docker volume create nexus_data

docker run -d \
  --name nexus \
  -p 8081:8081 \
  -m 1024m \
  -v nexus_data:/nexus-data \
  sonatype/nexus3