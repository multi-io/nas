#!/bin/sh

# dhcp lease range 192.168.142.50..150 => container range 192.168.142.16/28 (.16....31)
docker network create \
    -d macvlan  \
    --subnet=192.168.142.0/24  \
    --ip-range=192.168.142.16/28 \
    --gateway=192.168.142.1  \
    -o parent=enp2s0 pubnet
