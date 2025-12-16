# -----------------------------
# GRAFANA INSTALLATION
# -----------------------------
echo "===== Installing Grafana ====="

sudo apt install -y apt-transport-https software-properties-common wget

# Add Grafana GPG key
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Add Grafana repo (automated)
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Install Grafana
sudo apt update -y
sudo apt install -y grafana

# Start Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# -----------------------------
# FINAL STATUS
# -----------------------------

echo "Grafana Status:"
sudo systemctl status grafana-server --no-pager

echo "----------------------------------"
echo "Grafana URL   : http://<EC2-IP>:3000"
echo "Grafana Login : admin / admin"
echo "----------------------------------"
