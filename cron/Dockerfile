FROM ubuntu:18.04
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_ID=1000
ARG USER_NAME=oklischat
ARG USERS_GROUP=users
ARG USERS_MORE_GROUPS="sudo,dialout"
ARG USER_FULLNAME="Olaf Klischat"
ARG USER_EMAIL=olaf@invalid.de
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get -yy upgrade && \
    apt-get -yy install locales && \
    locale-gen en_US.UTF-8; locale-gen de_DE.UTF-8 && \
    apt-get -yy install cron

COPY user-crontab /var/spool/cron/crontabs/${USER_NAME}

RUN groupadd -g ${USER_ID} ${USER_NAME} && \
    useradd -u ${USER_ID} -s /bin/bash -d /home/${USER_NAME} -g ${USERS_GROUP} -G "${USER_NAME},${USERS_MORE_GROUPS}" ${USER_NAME} && \
    chown "${USER_NAME}:crontab" /var/spool/cron/crontabs/${USER_NAME} && \
    chmod 600 /var/spool/cron/crontabs/${USER_NAME}

ENTRYPOINT ["/usr/sbin/cron"]
CMD ["-f"]
