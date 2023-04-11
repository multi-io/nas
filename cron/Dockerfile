FROM ubuntu:22.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get -yy upgrade && \
    apt-get -yy install locales && \
    locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8 && \
    apt-get -yy install cron docker.io && \
    rm -rf /etc/cron.*/*

COPY hostbackup-daily /etc/cron.daily/hostbackup
COPY hostbackup-weekly /etc/cron.weekly/hostbackup
COPY hostbackup-monthly /etc/cron.monthly/hostbackup

COPY backup-host /usr/local/bin/

COPY docker-prune /etc/cron.daily/

ENTRYPOINT ["/usr/sbin/cron"]
CMD ["-f"]
