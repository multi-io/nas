FROM ubuntu:16.10
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

RUN locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get -yy upgrade

RUN apt-get -yy install openssh-server supervisor sudo bash-completion man git etckeeper less vim emacs curl wget

COPY run-sshd.sh /usr/local/bin/run-sshd.sh
RUN chmod ugo+x /usr/local/bin/run-sshd.sh

RUN groupadd -g 1000 olaf
RUN useradd -u 1000 -s /bin/bash -d /home/olaf -g users -G olaf,sudo -p '$6$DR2WkWWU$NZkLCzN10KdmA7LJodvKLcraXWdL/tfzriXu68QpeOz8aumwvAZpNdX1pflxBW.BnMvP61y.8HZ0KGYSCifRR0' olaf

COPY services.conf /etc/supervisor/conf.d/services.conf

RUN git config --global user.email "olaf.klischat@gmail.com"
RUN git config --global user.name "Olaf Klischat"

RUN apt-get -yy install ruby bc lsb-release make gcc net-tools tmux iputils-ping iputils-arping iputils-tracepath tcpdump whois netcat

CMD ["/usr/bin/supervisord"]

