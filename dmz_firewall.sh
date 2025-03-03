#!/bin/bash

#Install UFW if it is not already installed
sudo apt install -y ufw


# Blocca tutto il traffico in uscita
sudo ufw default deny outgoing

# Blocca tutto il traffico in entrata
sudo ufw default deny incoming

# Block Facebook domain
sudo ufw deny out to any app Facebook

# Enable UFW
sudo ufw enable

# Reload UFW to apply changes
sudo ufw reload