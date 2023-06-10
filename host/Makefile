INVENTORY=hosts.tack
ANSIBLE_PARAMS=

%: %.yml
	ansible-playbook $(ANSIBLE_PARAMS) -i $(INVENTORY) $@.yml

create_vagrant_machine:
	vagrant up

destroy_vagrant_machine:
	vagrant destroy

regenerate_dockerd_pki:
	rm -fr roles/dockerd/out/*
	$(MAKE) dockerd
