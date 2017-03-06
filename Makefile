run:
	# total hack to avoid having the cleartext passwords in committed files:
	# Makefile decrypts (locally), Dockerfiles uploads, image runtime arguments pass it to samba.sh to create the user
	$(MAKE) -C samba data/password
	docker-compose up -d --build; $(MAKE) -C samba clean

build:
	docker-compose build
