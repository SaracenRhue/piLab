#!/bin/bash

# Base URL for the GitHub repository
BASE_URL="https://raw.githubusercontent.com/SaracenRhue/piLab/main/config/"

# List of files to download
FILES=(
    "dhcpcd.conf"
    "routed-ap.conf"
    "dnsmasq.conf"
    "hostapd.conf"
    "pilab"
    "99-custom"
)

# Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget git htop samba dnsmasq hostapd dhcpcd5 deborphan
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent
curl -fsSL https://get.casaos.io | sudo bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo apt install -y python-is-python3
sudo apt autoremove -y && sudo apt clean
sudo deborphan | xargs sudo apt purge -y

# Configurations
# Loop through the files and download each one
for file in "${FILES[@]}"; do
    echo "Downloading $file..."
    wget "${BASE_URL}${file}" -O "${file}"
done
echo "Download complete."
sudo hostnamectl set-hostname pilab
sudo systemctl unmask hostapd.service
sudo /etc/dhcpcd.conf /etc/dhcpcd.conf.old
sudo mv dhcpcd.conf /etc/dhcpcd.conf
sudo mv routed-ap.conf /etc/sysctl.d/routed-ap.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo netfilter-persistent save
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
sudo mv dnsmasq.conf /etc/dnsmasq.conf
sudo mkdir /etc/hostapd/
sudo mv hostapd.conf /etc/hostapd/hostapd.conf
sudo mv pilab /usr/local/bin/pilab
sudo mv /etc/update-motd.d/99-custom
sudo chmod +x /usr/local/bin/pilab
sudo chmod +x /etc/update-motd.d/99-custom

# Permissions
sudo chmod -R u+rwx /DATA
sudo usermod -aG docker $USER
sudo smbpasswd -a $USER

# Services
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable dhcpcd
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq
sudo systemctl restart dhcpcd
sudo systemctl restart smbd

sudo tailscale up # --advertise-routes=10.10.20.0/24
