#!/bin/bash

# Installa UFW (Uncomplicated Firewall) se non è già installato
apt-get update
apt install -y ufw

# Blocca tutto il traffico in uscita
ufw default deny outgoing

# Blocca tutto il traffico in entrata
ufw default deny incoming

# Permetti il traffico in uscita sulla porta 53 (DNS) per risolvere i nomi di dominio
ufw allow out 53

# Permetti il traffico in entrata sulla porta 22 (SSH) per poter accedere al server
ufw allow in 22
ufw allow in 80

# Abilita UFW (Uncomplicated Firewall)
ufw enable

echo "Configurazione del firewall completata."