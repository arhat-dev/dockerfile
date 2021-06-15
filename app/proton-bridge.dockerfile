ARG ARCH=amd64

FROM ghcr.io/arhat-dev/builder-go:debian-${ARCH} AS builder
FROM ghcr.io/arhat-dev/go:debian-${ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

RUN addgroup -g 1000 proton-bridge ;\
    adduser -h /home/proton -s $(which nologin) -S -D -u 1000 proton-bridge ;\
    mkdir -p /data ;\
    chown -R proton-bridge:proton-bridge /data

RUN apt install -y --no-install-recommends \
      expect socat pass libsecret-1 ca-certificates

COPY entrypoint.sh login.exp /usr/local/bin/

RUN chmod +x /usr/local/bin/login.exp /usr/local/bin/entrypoint.sh

# SMTP STARTTLS
EXPOSE 9587/tcp

# IMAP STARTTLS
EXPOSE 9143/tcp

USER 1000

VOLUME [ "/data" ]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["start"]
