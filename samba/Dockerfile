FROM alpine
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_NAME=olaf
ARG USERID
ARG GROUPID

# Install samba
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash samba shadow tini tzdata gettext && \
    addgroup -S smb && \
    adduser -S -D -H -h /tmp -s /sbin/nologin -G smb -g 'Samba User' smbuser &&\
    file="/etc/samba/smb.conf" && \
    sed -i 's|^;* *\(log file = \).*|   \1/dev/stdout|' $file && \
    sed -i 's|^;* *\(load printers = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(printcap name = \).*|   \1/dev/null|' $file && \
    sed -i 's|^;* *\(printing = \).*|   \1bsd|' $file && \
    sed -i 's|^;* *\(unix password sync = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(short preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(default case = \).*|   \1lower|' $file && \
    sed -i '/Share Definitions/,$d' $file && \
    echo '   include = /etc/samba/smb.conf.custom' >>$file && \
    echo '' >>$file && \
    rm -rf /tmp/*

COPY smb.conf.custom /tmp/
RUN cat /tmp/smb.conf.custom | envsubst >/etc/samba/smb.conf.custom
COPY samba.sh /usr/bin/
# TODO try to avoid having the unencrypted password in this layer in /tmp/password
COPY data/password /tmp/

RUN samba.sh -u "${USER_NAME};/tmp/password" /bin/true && rm -f /tmp/password /tmp/smb.conf.custom

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/samba.sh"]
