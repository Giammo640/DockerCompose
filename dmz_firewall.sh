#!/bin/bash

#Install UFW if it is not already installed
sudo apt install -y ufw

echo "Fetching Facebook IP ranges..."
IP_RANGES=$(whois AS32934 | grep -E "inetnum|NetRange" | awk '{print $2}')


# Blocca tutto il traffico in entrata
sudo ufw default deny incoming


# Block each IP range
echo "Blocking Facebook IPs with UFW..."
for IP in $IP_RANGES; do
    sudo ufw deny out to $IP
    sudo ufw deny in from $IP
    echo "Blocked: $IP"
done

sudo ufw allow in to any port 80
sudo ufw allow in to any port 443

# Enable UFW
sudo ufw enable

# Reload UFW to apply changes
sudo ufw reload