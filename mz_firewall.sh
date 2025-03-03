#!/bin/bash

# Installa UFW (Uncomplicated Firewall) se non è già installato
sudo apt install -y ufw

# Blocca tutto il traffico in uscita
sudo ufw default deny outgoing

# Blocca tutto il traffico in entrata
sudo ufw default deny incoming

# Permetti il traffico in uscita sulla porta 53 (DNS) per risolvere i nomi di dominio
sudo ufw allow out 53

# Permetti il traffico in entrata sulla porta 22 (SSH) per poter accedere al server
sudo ufw allow in 22
sudo ufw allow in 80

# Abilita UFW (Uncomplicated Firewall)
sudo ufw enable

echo "Configurazione del firewall completata."