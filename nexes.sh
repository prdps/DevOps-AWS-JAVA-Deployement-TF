#!/bin/bash
set -e

# Install Java
apt update -y
apt install -y openjdk-21-jdk 

# Create user
id nexus || useradd -m nexus

# Install Nexus

wget https://cdn.download.sonatype.com/repository/downloads-prod-group/3/nexus-3.90.1-01-linux-x86_64.tar.gz
tar -xzf nexus-3.90.1-01-linux-x86_64.tar.gz
mv nexus-3.90.1-01 /opt/nexus


chown -R nexus:nexus /opt/nexus
mkdir -p /opt/sonatype-work
chown -R nexus:nexus /opt/sonatype-work

# Set Nexus to run as nexus user
sed -i 's/#run_as_user=""/run_as_user="nexus"/' /opt/nexus/bin/nexus.rc

# 🔧 Reduce JVM memory to 512 MB
sed -i 's/^-Xms.*/-Xms512m/' /opt/nexus/bin/nexus.vmoptions
sed -i 's/^-Xmx.*/-Xmx512m/' /opt/nexus/bin/nexus.vmoptions

# Start Nexus
su - nexus -c "/opt/nexus/bin/nexus start"