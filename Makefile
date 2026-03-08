run: build
	./dcompose.sh up -d --build $(SVC)

build:
	# copy backup-host script for the cron container. Docker doesn't accept COPY ../ references or a symlink
	if grep -q "cron" <<<"$(SVC)" || [[ -z "$(SVC)" ]]; then cp -f ./backup-host cron/ && ./backup-host -r; fi
	./dcompose.sh build $(SVC)

up:
	./dcompose.sh up -d $(SVC)

hostinstall:
	$(MAKE) -C host nas

clean:
	./dcompose.sh down

superclean:
	./dcompose.sh down --rmi all
