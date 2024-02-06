#!/bin/bash

# Base URL for the GitHub repository
BASE_URL="https://raw.githubusercontent.com/SaracenRhue/piLab/main/config/"

# List of files to download
FILES=(
    "dhcpcd.conf"
    "routed-ap.conf"
    "dnsmasq.conf"
    "hostapd.conf"
    #"pilab"
    "99-custom"
    "smb.conf"
)

# Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget git htop tmux samba dnsmasq hostapd dhcpcd5 deborphan
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent
curl -fsSL https://tailscale.com/install.sh | sh
sudo apt install -y python-is-python3

if [ -n "$ZSH_VERSION" ]; then
    sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting neofetch
    echo "plugins=(zsh-autosuggestions)" >> ~/.zshrc
    sudo git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
    curl -L http://install.ohmyz.sh | sh
    echo "clear && neofetch" >> ~/.zshrc
fi

# Configurations
# Loop through the files and download each one
for file in "${FILES[@]}"; do
    echo "Downloading $file..."
    wget "${BASE_URL}${file}" -O "${file}"
done
echo "Download complete."
sudo hostnamectl set-hostname pilab
sudo systemctl unmask hostapd.service
sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.old
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
#sudo mv pilab /usr/local/bin/pilab
sudo mv /etc/update-motd.d/99-custom
sudo mv smb.conf /etc/samba/smb.conf
#sudo chmod +x /usr/local/bin/pilab
sudo chmod +x /etc/update-motd.d/99-custom


# Services
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable dhcpcd
sudo systemctl enable smbd
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq
sudo systemctl restart dhcpcd
sudo systemctl restart smbd

sudo apt install cockpit cockpit-packagekit cockpit-storaged cockpit-machines cockpit-podman cockpit-pcp -y
curl -sSL https://repo.45drives.com/setup | sudo bash
sudo apt update && sudo apt install cockpit-file-sharing cockpit-navigator -y

sudo mkdir /appdata && chmod 777 /appdata

mkdir /appdata/minecraft
podman run -d --name=minecraft -e TZ=Europe/Berlin -e TYPE=paper -e OPS=Caeser -e MODE=survival -e MEMORY=1G -e VERSION=1.19 -e EULA=true -p 25565:25565/tcp -v /appdata/minecraft:/data:rw  docker.io/itzg/minecraft-server:latest
podman stop minecraft

curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
sudo systemctl stop docker
sudo systemctl disable docker

sudo apt autoremove -y && sudo apt clean
sudo deborphan | xargs sudo apt purge -y
read -p "Press ENTER to finish setup..."

chsh -s $(which zsh)
sudo tailscale up # --advertise-routes=10.10.20.0/24
