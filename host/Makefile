INVENTORY=hosts.tack
ANSIBLE_PARAMS=

default: setup_host

%: %.yml
	./run-playbook $(ANSIBLE_PARAMS) -i $(INVENTORY) $@.yml

create_vagrant_machine:
	vagrant up

destroy_vagrant_machine:
	vagrant destroy

regenerate_dockerd_pki:
	rm -fr roles/dockerd/out/*
	$(MAKE) dockerd

DOCKER_MACHINE_NAME=tack

_TARGET="$(HOME)/.docker/machine/machines/$(DOCKER_MACHINE_NAME)/"

create_docker_machine_client_conf:
	mkdir -p "$(_TARGET)"
	cp -a "roles/dockerd/out/$(DOCKER_MACHINE_NAME)/ca.pem" "$(_TARGET)/"
	cp -a "roles/dockerd/out/$(DOCKER_MACHINE_NAME)/client.pem" "$(_TARGET)/cert.pem"
	cp -a "roles/dockerd/out/$(DOCKER_MACHINE_NAME)/client-key.pem" "$(_TARGET)/key.pem"
	@printf "please add to your profile/rc/whatever:\nexport DOCKER_CERT_PATH=$(_TARGET)\nexport DOCKER_HOST=tcp://$(DOCKER_MACHINE_NAME):2376\nexport DOCKER_TLS_VERIFY=1\n"
	
# TODO generate $(_TARGET)/config.json as well the user can also use `eval $(docker-machine env $(DOCKER_MACHINE_NAME))`
