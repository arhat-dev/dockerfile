ARG ARCH=amd64

FROM ghcr.io/arhat-dev/builder-go:alpine AS builder
FROM ghcr.io/arhat-dev/go:alpine-${ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

RUN addgroup -g 1000 proton-bridge ;\
    adduser -h /home/proton -s $(which nologin) -S -D -u 1000 proton-bridge ;\
    mkdir -p /data ;\
    chown -R proton-bridge:proton-bridge /data

RUN apk add expect socat pass ca-certificates coreutils libnotify

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
