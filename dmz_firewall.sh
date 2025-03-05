#!/bin/bash

# Abilita il forwarding dei pacchetti essenziale per funzionare da router/firewall
echo "1" > /proc/sys/net/ipv4/ip_forward

# Pulisce le vecchie regole
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X


# Accetta tutto il traffico nella rete interna, permette ai servizi interni alla rete di comunicare liberamente
iptables -A FORWARD -i dmz_internal -j ACCEPT

# Applica le regole firewall per il traffico in entrata e uscita, accetta le connessioni già stabilite.
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#Queste regole permettono solo il traffico HTTP/S in entrata datta rete dmz_network e quella interna
iptables -A FORWARD -i dmz_network -o dmz_internal -p tcp --dport 80 -j ACCEPT  # Solo HTTP consentito
iptables -A FORWARD -i dmz_network -o dmz_internal -p tcp --dport 443 -j ACCEPT # Solo HTTPS consentito

# Questa regola abilita il masquerading, cioè traduce gli indirizzi IP della rete interna (dmz_internal) 
# in quello del firewall prima di inoltrare i pacchetti alla rete dmz_network.
iptables -t nat -A POSTROUTING -o dmz_network -j MASQUERADE

