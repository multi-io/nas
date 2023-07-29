FROM alpine:3.18.2
MAINTAINER Olaf Klischat <olaf.klischat@gmail.com>

ARG USER_NAME
ARG USER_ID
ARG USER_PASSWORD
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
    echo '' >>$file

COPY smb.conf.custom /tmp/

RUN cat /tmp/smb.conf.custom | envsubst >/etc/samba/smb.conf.custom && \
    if ! grep -q "^${USERS_GROUP}:" /etc/group; then groupadd "${USERS_GROUP}" -g "${USERS_GID}"; fi && \
    groupmod -g "${USERS_GID}" "${USERS_GROUP}" && \
    useradd "${USER_NAME}" -M -u "${USER_ID}" -g "${USERS_GROUP}" && \
    echo -e "${USER_PASSWORD}\n${USER_PASSWORD}" | smbpasswd -s -a "${USER_NAME}" && \
    rm -f /tmp/smb.conf.custom

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

ENTRYPOINT ["/sbin/tini", "--", "/bin/sh", "-c", "exec ionice -c 3 smbd -F --debug-stdout --no-process-group </dev/null"]
