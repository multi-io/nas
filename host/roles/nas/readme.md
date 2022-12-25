Installs a systemd unit that brings up the docker-compose setup on the host.
Doesn't try to build the images for now (because that would require user
interaction, e.g. when the decryption passphrase for the samba credentials is
required). So on a new, empty host or after any changes to the docker-compose
setup you'll still need to run "docker-compose up" manually from somwehere to
build the new images. This service unit is mainly meant to make this setup come
up automatically at boot time.
