#!/usr/bin/env bash

set -e

if [[ -z "${VPN_SUBNET}" || -z "${LAN_SUBNET}" ]]; then
    echo "VPN_SUBNET or LAN_SUBNET unset" >&2
    exit 1
fi

# masquerade (snat) traffic leaving the VPN subnet to the LAN subnet
nft add rule nat POSTROUTING oifname eth0 ip saddr "${VPN_SUBNET}.0/24" masquerade

KEY_FILE=/wg-key/private.key

if [[ ! -f $KEY_FILE ]]; then
    tmpfile=$(mktemp)
    wg genkey > $tmpfile
    mv $tmpfile $KEY_FILE
fi

config=/etc/wireguard/wg0.conf

cat > $config <<EOF
[Interface]
PrivateKey = $(<$KEY_FILE)
Address = ${VPN_SUBNET}.1/24
ListenPort = 41414

EOF

if [[ -f /peers.conf ]]; then
    cat /peers.conf >> $config
fi

wg-quick up wg0

echo "public key: $(<$KEY_FILE wg pubkey)"

/bin/sleep infinity