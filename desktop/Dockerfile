FROM ubuntu:16.10
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_ID=1000
ARG USER_NAME=oklischat
ARG USERS_GROUP=users
ARG USERS_MORE_GROUPS="sudo,dialout"
ARG USER_FULLNAME="Olaf Klischat"
ARG USER_EMAIL=olaf@invalid.de

RUN locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get -yy upgrade && \
    apt-get -yy install openssh-server supervisor sudo bash-completion man git etckeeper less vim emacs curl wget links mplayer mencoder jpeginfo imagemagick

COPY run-sshd.sh /usr/local/bin/run-sshd.sh
COPY services.conf /etc/supervisor/conf.d/services.conf

RUN chmod ugo+x /usr/local/bin/run-sshd.sh && \
    groupadd -g ${USER_ID} ${USER_NAME} && \
    useradd -u ${USER_ID} -s /bin/bash -d /home/${USER_NAME} -g ${USERS_GROUP} -G "${USER_NAME},${USERS_MORE_GROUPS}" -p '$6$DR2WkWWU$NZkLCzN10KdmA7LJodvKLcraXWdL/tfzriXu68QpeOz8aumwvAZpNdX1pflxBW.BnMvP61y.8HZ0KGYSCifRR0' ${USER_NAME} && \
    git config --global user.email "${USER_EMAIL}" && \
    git config --global user.name "${USER_FULLNAME}" && \
    curl -s https://releases.hashicorp.com/vagrant/1.9.2/vagrant_1.9.2_x86_64.deb >/tmp/vagrant.deb && dpkg -i /tmp/vagrant.deb && rm -f /tmp/vagrant.deb && \
    apt-get -yy install ruby ruby-dev g++ bc lsb-release make gcc net-tools tmux iputils-ping iputils-arping iputils-tracepath tcpdump whois netcat dialog virtualbox gnupg dirmngr docker.io unrar cu irssi ffmpeg python3-venv && \
    curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && \
    chmod a+rx /usr/local/bin/youtube-dl

CMD ["/usr/bin/supervisord"]

