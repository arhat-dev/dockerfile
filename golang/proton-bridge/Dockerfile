ARG MATRIX_ARCH
ARG MATRIX_ROOTFS

FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

COPY . /app

ARG MATRIX_KERNEL
ARG MATRIX_ARCH

RUN set -eux ;\
    dukkha golang local build proton-bridge \
    -m kernel=${MATRIX_KERNEL} \
    -m arch=${MATRIX_ARCH}

COPY golang/proton-bridge/entrypoint.sh /usr/local/bin/entrypoint
COPY golang/proton-bridge/login.exp /usr/local/bin/login.exp

RUN set -eux ;\
    mv "/output/proton-bridge.${MATRIX_KERNEL}.${MATRIX_ARCH}/proton-bridge" \
        /usr/local/bin/proton-bridge ;\
    chmod a+x /usr/local/bin/*

FROM ghcr.io/arhat-dev/golang:1.16-${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=builder /usr/local/bin/* /usr/local/bin/

ARG MATRIX_ROOTFS
COPY golang/proton-bridge/setup.sh /setup.sh
RUN sh /setup.sh "${MATRIX_ROOTFS}" && rm -f /setup.sh

# SMTP STARTTLS
EXPOSE 9587/tcp

# IMAP STARTTLS
EXPOSE 9143/tcp

# use uid for kubernetes runAsNonRoot=true check
USER 1000

VOLUME [ "/data" ]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["start"]
