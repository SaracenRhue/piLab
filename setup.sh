#!/bin/bash

# Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget git htop samba dnsmasq hostapd dhcpcd5
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent
curl -fsSL https://get.casaos.io | sudo bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo apt autoremove
# Configurations
sudo hostnamectl set-hostname pilab
sudo systemctl unmask hostapd.service
cp dhcpcd.conf /etc/dhcpcd.conf
cp routed-ap.conf /etc/sysctl.d/routed-ap.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo netfilter-persistent save
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
cp dnsmasq.conf /etc/dnsmasq.conf
cp hostapd.conf /etc/hostapd/hostapd.conf
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
