ARG MATRIX_ROOTFS
ARG MATRIX_ARCH
ARG HOST_ARCH

FROM ghcr.io/arhat-dev/builder-go:${MATRIX_ROOTFS}-${HOST_ARCH} AS builder

ARG MATRIX_ARCH
ARG MATRIX_ROOTFS
ARG APP

COPY golang/wal-g/setup.sh /setup.sh
RUN sh /setup.sh && rm -rf /setup.sh

COPY . /app
WORKDIR /app
RUN set -eux ;\
    dukkha golang local build \
    ${APP} \
    -m kernel=linux \
    -m arch=${MATRIX_ARCH} \
    -m rootfs=${MATRIX_ROOTFS}

FROM ghcr.io/arhat-dev/go:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
ARG MATRIX_ROOTFS
ARG APP
COPY --from=builder /app/build/* /
