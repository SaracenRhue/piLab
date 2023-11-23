#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo hostnamectl set-hostname pilab
sudo apt install -y wget git htop dnsmasq 
curl -fsSL https://get.casaos.io | sudo bash
curl -fsSL https://tailscale.com/install.sh | sh


sudo tailscale up --advertise-routes=10.10.20.0/24
