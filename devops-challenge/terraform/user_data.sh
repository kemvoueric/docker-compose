#!/bin/bash
set -ex

# Log output for debugging
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# --------------------------------------------------------
# Install Docker and Docker Compose
# --------------------------------------------------------
yum update -y

# Remove any old Docker versions
dnf remove -y docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine || true

# Install the Docker CE repository and packages
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
systemctl enable --now docker

# --------------------------------------------------------
# Deploy Flask container
# --------------------------------------------------------
mkdir -p /opt/flask-app
cd /opt/flask-app

# Create a docker-compose.yml for a simple Flask app
cat > docker-compose.yml <<'EOF'
version: "3.8"

services:
  flask-app:
    image: tiangolo/uwsgi-nginx-flask:python3.9
    container_name: flask-app
    ports:
      - "80:80"
    restart: always
    environment:
      - FLASK_APP=app.py
    volumes:
      - ./app:/app
EOF

# Create a simple Flask app
mkdir -p /opt/flask-app/app
cat > /opt/flask-app/app/app.py <<'EOF'
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Hello from Flask running on EC2 with Terraform!</h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
EOF

# --------------------------------------------------------
# Start the Flask container
# --------------------------------------------------------
docker compose -f /opt/flask-app/docker-compose.yml up -d
