ARG HOST_ARCH
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:1.16-debian-${HOST_ARCH}-${MATRIX_ARCH} AS builder

ARG TARGET_DEBIAN_ARCH
ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux ;\
    apt-get update ;\
    # wal-g build script will download libsodium, do not install
    apt-get install -y cmake "liblzo2-dev:${TARGET_DEBIAN_ARCH}" ;\
    rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app

ARG MATRIX_ARCH

RUN set -eux ;\
    dukkha golang local build wal-g \
        -m kernel=linux \
        -m "arch=${MATRIX_ARCH}"

FROM scratch

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
COPY --from=builder /output/wal-g.linux.${MATRIX_ARCH}/* /
