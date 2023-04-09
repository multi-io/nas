run: build
	./dcompose.sh up -d --build $(SVC); $(MAKE) -C samba clean

build: # ovpn-config
	# hack to avoid having the cleartext passwords in committed files:
	# Makefile decrypts (locally), Dockerfile configures it in the image using smbpasswd
	$(MAKE) -C samba data/password
	set -a; . ./_getenv.sh && $(MAKE) ovpn-config
	# copy backup-host script for the cron container. Docker doesn't accept COPY ../ references or a symlink
	if [[ "$(SVC)" = "cron" ]]; then cp -f ./backup-host cron/ && ./backup-host -r; fi
	./dcompose.sh build $(SVC)

up:
	./dcompose.sh up -d $(SVC)

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

_rm-ovpn-config:
	docker volume rm -f ovpn-config
	rm -f ovpn-config.tgz $(VPN_CLIENTNAME).ovpn

rm-ovpn-config:
	set -a; . ./_getenv.sh && $(MAKE) _rm-ovpn-config

clean:
	./dcompose.sh down

superclean:
	./dcompose.sh down --rmi all
	set -a; . ./_getenv.sh && $(MAKE) _rm-ovpn-config
