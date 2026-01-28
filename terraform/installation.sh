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
  ca-certificates \
  gnupg \
  lsb-release \
  fontconfig \
  openjdk-17-jre

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
chmod +x /usr/local/bin/kind

#################################
# Install Jenkins
#################################
echo "Installing Jenkins..."

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  gpg --dearmor -o /usr/share/keyrings/jenkins.gpg

echo "deb [signed-by=/usr/share/keyrings/jenkins.gpg] \
  https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y
apt-get install -y jenkins
systemctl enable --now jenkins

#################################
# Final status
#################################
echo "Bootstrap completed successfully"

echo "Jenkins initial admin password:"
cat /var/lib/jenkins/secrets/initialAdminPassword || true
git clone https://github.com/solankivishnu63/DevOps-Project.git /devops-project