Basic usage:

* port `${LAN_SUBNET}.19:41414/udp` needs to be opened to the internet

* container will create keypair on the first launch, store private key in `wireguard-key` volume

* to add additional peers, run `wireguard/add-peer.sh 'peer name'`, e.g. `wireguard/add-peer.sh 'phone'`

* that will read the server public key from the running container, create a new keypair and config for the peer, append the server-side config for the peer to `wireguard/peers.conf`, and output the peer-side config to stdout, as file contents as well as QR code (requires "qrencode" tool)

* copy the file to the peer, either using copy&paste or by scanning the QR code

* restart the server (`make SVC=vpn run` or full `make hostinstall`)

* connecting from the client should now work

* make sure to store and keep the peers.conf -- it contains the peer public keys and is needed to start the server
