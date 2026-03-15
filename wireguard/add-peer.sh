#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

comment="$1"

if [[ -z "$comment" ]]; then
    echo "Usage: $0 <comment>"
    echo "generates a peer config for the given comment,"
    echo "adds it to peers.conf, creates peer-side config and outputs it verbatim and as a qr code."
    echo "To activate it, restart the vpn container and initialize the peer with the peer-side config"
    exit 1
fi

. ../_getenv.sh

server_pubkey="$(docker logs nas-vpn-1 2>&1 | perl -ne 'if (/^public key: (.*)/) { print $1; }')"

if [[ -z $server_pubkey ]]; then
    echo "Failed to get server public key"
    exit 1
fi

privkey=$(wg genkey)
pubkey=$(echo $privkey | wg pubkey)

if [[ ! -f peers.conf ]]; then
    touch peers.conf
fi

peer_nr=$(( 2 + $(grep '\[Peer\]' peers.conf | wc -l) ))
peer_address="${VPN_SUBNET}.${peer_nr}"

peer_conf=$(mktemp)

# on the peer side, the peer is the interface, and this server is a peer
cat <<EOF > $peer_conf
[Interface]
PrivateKey = $privkey
Address = $peer_address/32
ListenPort = 41414

[Peer]
PublicKey = $server_pubkey
AllowedIPs = ${VPN_SUBNET}.1/32,${LAN_SUBNET}.0/24
Endpoint = ${PUBLIC_HOSTNAME}:41414
EOF

cat <<EOF >> peers.conf
# $comment
[Peer]
PublicKey = $pubkey
AllowedIPs = ${VPN_SUBNET}.${peer_nr}/32

EOF

echo "peer config:"
echo "--------------------------------"
cat $peer_conf
echo "--------------------------------"

echo "peer config as qr code:"
qrencode -t UTF8 < $peer_conf