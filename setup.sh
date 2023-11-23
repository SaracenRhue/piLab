#!/bin/bash

# Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget git htop samba dnsmasq hostapd dhcpcd5
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent
curl -fsSL https://get.casaos.io | sudo bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo apt autoremove
# Configurations
wget https://github.com/SaracenRhue/piLab/main/dhcpcd.conf
wget https://github.com/SaracenRhue/piLab/main/routed-ap.conf
wget https://github.com/SaracenRhue/piLab/main/dnsmasq.conf
wget https://github.com/SaracenRhue/piLab/main/hostapd.conf
sudo hostnamectl set-hostname pilab
sudo systemctl unmask hostapd.service
sudo mv dhcpcd.conf /etc/dhcpcd.conf
sudo mv routed-ap.conf /etc/sysctl.d/routed-ap.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo netfilter-persistent save
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
sudo mv dnsmasq.conf /etc/dnsmasq.conf
sudo mv hostapd.conf /etc/hostapd/hostapd.conf
# Services
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable dhcpcd
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq
sudo systemctl restart dhcpcd
# Permissions
sudo chmod -R u+rwx /DATA
sudo smbpasswd -a $(whoami)
sudo tailscale up # --advertise-routes=10.10.20.0/24
