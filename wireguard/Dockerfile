FROM debian:bookworm-20260223

RUN apt-get update && \
    apt-get install -y iproute2 wireguard

COPY peers.conf* /peers.conf
COPY run-wg.sh /run-wg.sh

ENTRYPOINT ["/run-wg.sh"]
