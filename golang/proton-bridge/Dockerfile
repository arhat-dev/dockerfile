ARG MATRIX_ARCH
ARG MATRIX_ROOTFS

FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

COPY . /app

ARG MATRIX_ARCH
RUN dukkha golang local build proton-bridge -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/golang:1.16-${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_KERNEL
ARG MATRIX_ARCH
COPY --from=builder \
    "/app/build/${APP}.${MATRIX_KERNEL}.${MATRIX_ARCH}" \
    /proton-bridge

ARG MATRIX_ROOTFS
COPY golang/proton-bridge/setup.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh

COPY golang/proton-bridge/entrypoint.sh \
    golang/proton-bridge/login.exp \
    /usr/local/bin/

RUN chmod +x /usr/local/bin/login.exp /usr/local/bin/entrypoint.sh

# SMTP STARTTLS
EXPOSE 9587/tcp

# IMAP STARTTLS
EXPOSE 9143/tcp

USER proton-bridge

VOLUME [ "/data" ]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["start"]
