FROM alpine:3.17.2
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_NAME
ARG USER_ID
ARG USERS_GROUP
ARG USERS_GID

ENV WORKGROUP=WORKGROUP

# Install samba
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash samba shadow tini tzdata gettext && \
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
# TODO try to avoid having the unencrypted password in this layer in /tmp/password
COPY data/password /tmp/

RUN cat /tmp/smb.conf.custom | envsubst >/etc/samba/smb.conf.custom && \
    passwd="$(cat /tmp/password)" && rm -f "/tmp/password" && \
    if ! grep -q "^${USERS_GROUP}:" /etc/group; then groupadd "${USERS_GROUP}" -g "${USERS_GID}"; fi && \
    groupmod -g "${USERS_GID}" "${USERS_GROUP}" && \
    useradd "${USER_NAME}" -M -u "${USER_ID}" -g "${USERS_GROUP}" && \
    echo -e "$passwd\n$passwd" | smbpasswd -s -a "${USER_NAME}" && \
    rm -f /tmp/smb.conf.custom

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

ENTRYPOINT ["/sbin/tini", "--", "/bin/sh", "-c", "exec ionice -c 3 smbd -F --debug-stdout --no-process-group </dev/null"]
