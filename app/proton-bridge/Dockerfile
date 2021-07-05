ARG MATRIX_ARCH
ARG MATRIX_ROOTFS

FROM ghcr.io/arhat-dev/builder-go:alpine AS builder

COPY . /app

ARG MATRIX_ARCH
RUN dukkha golang build proton-bridge -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/go:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
COPY --from=builder /app/build/proton-bridge.linux.${MATRIX_ARCH} /proton-bridge

ARG MATRIX_ROOTFS
COPY app/proton-bridge/setup.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh

RUN set -ex ;\
    mkdir -p /data ;\
    chown -R proton-bridge:proton-bridge /data

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
