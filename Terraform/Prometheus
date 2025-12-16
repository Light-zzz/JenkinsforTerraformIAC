#!/bin/bash

set -e   # Exit immediately if any command fails

echo "===== Updating system ====="
sudo apt update && sudo apt upgrade -y

# -----------------------------
# PROMETHEUS INSTALLATION
# -----------------------------
echo "===== Installing Prometheus ====="

PROM_VERSION="2.51.0"

# Create prometheus user
sudo useradd --no-create-home --shell /bin/false prometheus || true

# Create directories
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Download Prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Extract
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Move binaries
sudo mv prometheus-${PROM_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/

# Move config files
sudo mv prometheus-${PROM_VERSION}.linux-amd64/consoles /etc/prometheus/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/console_libraries /etc/prometheus/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/prometheus.yml /etc/prometheus/

# Set permissions
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Create systemd service
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/

[Install]
WantedBy=multi-user.target
EOF

# Start Prometheus
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

#---------------------------------------
#End Of Script
#---------------------------------------
