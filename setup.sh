#!/bin/bash

# Dependencies
sudo apt update && sudo apt upgrade -y
sudo hostnamectl set-hostname pilab
sudo apt install -y wget git htop samba dnsmasq 
curl -fsSL https://get.casaos.io | sudo bash
curl -fsSL https://tailscale.com/install.sh | sh
# Configurations

# Services

# Permissions
sudo smbpasswd -a $(whoami)

sudo tailscale up --advertise-routes=10.10.20.0/24
