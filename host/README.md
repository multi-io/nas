Create user and setup home directory. Default user name: oklischat

`ansible-playbook -i hosts.vagrant create_and_setup_user.yml`

Different username (variable "username"):

`ansible-playbook -i hosts.vagrant -e username=olaf create_and_setup_user.yml`

Only set up the home directory for an existing user account:

`ansible-playbook -i hosts.vagrant -e username=olaf setup_user.yml`
