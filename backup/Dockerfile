FROM ubuntu:22.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ENV BACKUPNAME backup1

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get -yy upgrade && \
    apt-get -yy install locales && \
    locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8 && \
    apt-get -yy install nocache rsync rsnapshot

COPY run-backup rsnapshot.conf /

ENTRYPOINT ["/run-backup"]
