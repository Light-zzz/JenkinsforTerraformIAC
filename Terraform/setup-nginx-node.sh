#!/bin/bash

set -e
# Installing Nginx ----
    apt update -y
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx

echo "===== Installing Node Exporter ====="

NODE_EXPORTER_VERSION="1.8.1"

# Create node_exporter user
sudo useradd --no-create-home --shell /bin/false node_exporter || true

# Download Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

# Extract
tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

# Move binary
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

# Set ownership
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create systemd service
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "===== Node Exporter Installed Successfully ====="
