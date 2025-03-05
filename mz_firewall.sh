#!/bin/bash

# Abilita il forwarding dei pacchetti
echo "1" > /proc/sys/net/ipv4/ip_forward

# Pulisce le vecchie regole
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

#stabilisce la politica di default per i pacchetti in ingresso, uscita e transito (quello da fare se un pacchetto non corrisponde a nessuna regola)
iptables -P INPUT DROP      # Blocca tutto il traffico in ingresso
iptables -P FORWARD DROP    # Blocca tutto il traffico che attraversa il firewall
iptables -P OUTPUT DROP     # Blocca tutto il traffico in uscita (IMPORTANTE)



# Accetta tutto il traffico nella rete interna, permette il libero traffico nella rete interna
iptables -A INPUT -i mz_internal -j ACCEPT
iptables -A FORWARD -i mz_internal -o mz_internal -j ACCEPT

#!solo il database può comunicare con la rete esterna NON FUNZIONANTE
# iptables -A FORWARD -s <DB_IP> -d mz_external -j ACCEPT
# iptables -A FORWARD -s mz_external -d <DB_IP> -j ACCEPT

#permette connessioni già stabilite
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#Blocca tutto il resto del traffico 
iptables -A FORWARD -i mz_network -o eth0 -j DROP
iptables -A OUTPUT -o eth0 -j DROP

# NAT per permettere il traffico dalla rete interna verso l'esterno
iptables -t nat -A POSTROUTING -o mz_network -j MASQUERADE          #probabilmente qui andrevbbe aggiunto SOLO l'ip del database