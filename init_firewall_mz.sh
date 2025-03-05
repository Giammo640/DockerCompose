#!/bin/bash


ip route del default
ip route add default via 172.20.0.8 dev eth0

tail -f /dev/null