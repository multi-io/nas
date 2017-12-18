run: build
	./dcompose.sh up -d --build; $(MAKE) -C samba clean

build: # ovpn-config
	# hack to avoid having the cleartext passwords in committed files:
	# Makefile decrypts (locally), Dockerfiles uploads, image runtime arguments pass it to samba.sh to create the user
	$(MAKE) -C samba data/password
	set -a; . ./_getenv.sh && $(MAKE) ovpn-config
	./dcompose.sh build


OVPN_TMPVOL=ovpntmp

ovpn-config: ovpn-config.tgz $(VPN_CLIENTNAME).ovpn
	if ! docker volume inspect $@ >/dev/null 2>&1; then \
		docker volume create $@; \
		cat ovpn-config.tgz | docker run -v $@:/etc/openvpn --rm -i kylemanna/openvpn /bin/bash -c 'cd /etc/openvpn && tar xz'; \
	fi

$(VPN_CLIENTNAME).ovpn: ovpn-config.tgz
	docker run -v $(OVPN_TMPVOL):/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $(VPN_CLIENTNAME) > $@

ovpn-config.tgz:
	docker volume rm -f $(OVPN_TMPVOL)
	docker volume create $(OVPN_TMPVOL)
	docker run -v $(OVPN_TMPVOL):/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$(PUBLIC_HOSTNAME)
	docker run -v $(OVPN_TMPVOL):/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki	
	docker run -v $(OVPN_TMPVOL):/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $(VPN_CLIENTNAME) nopass
	docker run -v $(OVPN_TMPVOL):/etc/openvpn --rm -i kylemanna/openvpn /bin/bash -c 'cd /etc/openvpn && tar cz .' >$@

rm-ovpn-config:
	docker volume rm -f ovpn-config

clean:
	./dcompose.sh down

superclean:
	./dcompose.sh down --rmi all
	$(MAKE) rm-ovpn-config
