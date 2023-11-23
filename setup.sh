#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y wget git htop dnsmasq 
curl -fsSL https://get.casaos.io | sudo bash
curl -fsSL https://tailscale.com/install.sh | sh


sudo reboot
