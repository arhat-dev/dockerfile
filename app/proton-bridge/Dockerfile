ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-go:alpine AS builder

COPY . /app

ARG MATRIX_ARCH
RUN dukkha golang build proton-bridge -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/go:alpine-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
COPY --from=builder /app/build/proton-bridge.linux.${MATRIX_ARCH} /proton-bridge

RUN addgroup -g 1000 proton-bridge ;\
    adduser -h /home/proton -s $(which nologin) -S -D -u 1000 proton-bridge ;\
    mkdir -p /data ;\
    chown -R proton-bridge:proton-bridge /data

RUN apk add --no-cache expect socat pass ca-certificates coreutils libnotify

COPY app/proton-bridge/entrypoint.sh app/proton-bridge/login.exp /usr/local/bin/

RUN chmod +x /usr/local/bin/login.exp /usr/local/bin/entrypoint.sh

# SMTP STARTTLS
EXPOSE 9587/tcp

# IMAP STARTTLS
EXPOSE 9143/tcp

USER 1000

VOLUME [ "/data" ]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["start"]
