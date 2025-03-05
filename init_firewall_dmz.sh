#!/bin/bash

ip route del default
ip route add default via 172.21.0.18 dev eth0

tail -f /dev/null