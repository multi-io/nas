INVENTORY=hosts.vagrant
ANSIBLE_PARAMS=

setup_user create_and_setup_user setup_host setup_host_without_user admin_packages debian_base dockerd:
	ansible-playbook $(ANSIBLE_PARAMS) -i $(INVENTORY) $@.yml

create_vagrant_machine:
	vagrant up

destroy_vagrant_machine:
	vagrant destroy
