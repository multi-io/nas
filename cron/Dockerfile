FROM ubuntu:24.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get -yy upgrade && \
    apt-get -yy install locales && \
    locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8 && \
    apt-get -yy install cron docker.io docker-compose-v2 curl && \
    rm -rf /etc/cron.*/*

COPY crontab /etc/crontab
COPY daily/* /etc/cron.daily/
COPY weekly/* /etc/cron.weekly/
COPY monthly/* /etc/cron.monthly/

COPY run-monitored backup-host /usr/local/bin/

# pass the container environment to the cronjobs via /etc/environment
CMD set >>/etc/environment && exec /usr/sbin/cron -f
