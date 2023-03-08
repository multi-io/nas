FROM debian:stretch
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_NAME=olaf
ARG USERID
ARG GROUPID

# Install samba
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends procps samba gettext-base \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    useradd -c 'Samba User' -d /tmp -M -r smbuser && \
    sed -i 's|^\(   log file = \).*|\1/dev/stdout|' /etc/samba/smb.conf && \
    sed -i 's|^\(   unix password sync = \).*|\1no|' /etc/samba/smb.conf && \
    sed -i '/Share Definitions/,$d' /etc/samba/smb.conf && \
    echo '   include = /etc/samba/smb.conf.custom' >>/etc/samba/smb.conf && \
    echo '' >>/etc/samba/smb.conf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
COPY smb.conf.custom /tmp/
RUN cat /tmp/smb.conf.custom | envsubst >/etc/samba/smb.conf.custom
COPY samba.sh /usr/bin/
# TODO try to avoid having the unencrypted password in this layer in /tmp/password
COPY data/password /tmp/

RUN samba.sh -u "${USER_NAME};/tmp/password" /bin/true && rm -f /tmp/password /tmp/smb.conf.custom.tpl

EXPOSE 137/udp 138/udp 139 445

ENTRYPOINT ["samba.sh"]
