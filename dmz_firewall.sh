#!/bin/bash

#Install UFW if it is not already installed
apt-get update
apt install -y ufw

echo "Fetching Facebook IP ranges..."
IP_RANGES=$(whois AS32934 | grep -E "inetnum|NetRange" | awk '{print $2}')


# Blocca tutto il traffico in entrata
ufw default deny incoming


# Block each IP range
echo "Blocking Facebook IPs with UFW..."
for IP in $IP_RANGES; do
    ufw deny out to $IP
    ufw deny in from $IP
    echo "Blocked: $IP"
done

ufw allow in to any port 80
ufw allow in to any port 443

# Enable UFW
ufw enable

# Reload UFW to apply changes
ufw reload