INVENTORY=hosts.vagrant

setup_user create_and_setup_user setup_tack setup_tack_without_user admin_packages:
	ansible-playbook  -i $(INVENTORY) $@.yml
