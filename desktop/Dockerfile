FROM ubuntu:24.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_ID=1000
ARG USER_NAME=oklischat
ARG USERS_GROUP=users
ARG USERS_MORE_GROUPS="sudo,dialout"
ARG USER_FULLNAME="Olaf Klischat"
ARG USER_EMAIL=olaf@invalid.de
ARG NODEJS_VERSION=v16.1.0
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN yes | unminimize && \
    apt-get -yy install locales && \
    locale-gen en_US.UTF-8 && locale-gen de_DE.UTF-8 && \
    mkdir /etc/dma && touch /etc/dma/dma.conf && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install openssh-server supervisor sudo zsh bash-completion man git etckeeper less vim neovim emacs locate curl wget links mplayer mencoder jpeginfo imagemagick irssi inetutils-syslogd dma mailutils && \
    userdel ubuntu && \
    groupadd -g ${USER_ID} ${USER_NAME} && \
    useradd -u ${USER_ID} -s /bin/zsh -d /home/${USER_NAME} -g ${USERS_GROUP} -G "${USER_NAME},${USERS_MORE_GROUPS}" -p '$6$DR2WkWWU$NZkLCzN10KdmA7LJodvKLcraXWdL/tfzriXu68QpeOz8aumwvAZpNdX1pflxBW.BnMvP61y.8HZ0KGYSCifRR0' ${USER_NAME} && \
    git config --global user.email "${USER_EMAIL}" && \
    git config --global user.name "${USER_FULLNAME}" && \
    perl -i -ne 'if (/^PRUNEPATHS=/) { s!/media *!!; }; print' /etc/updatedb.conf && \
    curl -s https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb >/tmp/vagrant.deb && dpkg -i /tmp/vagrant.deb && rm -f /tmp/vagrant.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install ruby ruby-dev g++ bc lsb-release make gcc net-tools tmux iputils-ping iputils-arping iputils-tracepath tcpdump whois netcat-openbsd dialog virtualbox gnupg dirmngr docker.io unrar cu irssi ffmpeg virtualenv python3-venv python3-dev python3-gnuplot psmisc iptraf nethogs libpcap-dev nmap apt-file mkvtoolnix strace lsof rsync tig jq ripgrep fzf dnsutils webp file dlocate && \
    cd /usr/local/ && \
    wget https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.gz && \
    tar xzf node-${NODEJS_VERSION}-linux-x64.tar.gz && \
    rm -rf node-${NODEJS_VERSION}-linux-x64.tar.gz && \
    ln -sf $PWD/node-${NODEJS_VERSION}-linux-x64/bin/* bin/ && \
    apt update

COPY run-sshd.sh /usr/local/bin/run-sshd.sh
COPY initialize-container.sh /usr/local/bin/initialize-container.sh
COPY services.conf /etc/supervisor/conf.d/services.conf

CMD ["/usr/bin/supervisord"]

