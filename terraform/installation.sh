#!/bin/bash
set -e

# Log everything (very useful for Terraform debugging)
exec > /var/log/bootstrap.log 2>&1

DEFAULT_USER="ubuntu"

echo "Updating system..."
apt-get update -y

echo "Installing base packages..."
apt-get install -y \
  nginx \
  docker.io \
  curl \

echo "Enabling services..."
systemctl enable --now nginx
systemctl enable --now docker

# Add user to docker group (applies on first SSH login)
if id "$DEFAULT_USER" &>/dev/null; then
  usermod -aG docker "$DEFAULT_USER"
fi

#################################
# Install kind
#################################
echo "Installing kind..."
curl -fsSL -o /usr/local/bin/kind \
  https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
sudo chmod +x /usr/local/bin/kind

#################################
# Install Jenkins
#################################
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version
# this should be the result of the command above:
#openjdk 21.0.8 2025-07-15
#OpenJDK Runtime Environment (build 21.0.8+9-Debian-1)
#OpenJDK 64-Bit Server VM (build 21.0.8+9-Debian-1, mixed mode, sharing)

#Once you get this result then you can proceed with Jenkins installation
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins
#################################

# Kubectl installation
#################################
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
#################################
