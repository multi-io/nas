INVENTORY=hosts.vagrant
ANSIBLE_PARAMS=

setup_user create_and_setup_user setup_tack setup_tack_without_user admin_packages:
	ansible-playbook $(ANSIBLE_PARAMS) -i $(INVENTORY) $@.yml
