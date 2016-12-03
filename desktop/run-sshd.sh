#!/bin/sh

set -e

if [ ! -d /var/run/sshd ]; then
    mkdir /var/run/sshd
    chmod 0755 /var/run/sshd
fi

/usr/sbin/sshd -D

