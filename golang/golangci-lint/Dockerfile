ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

ARG MATRIX_ROOTFS
ARG MATRIX_KERNEL
ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build golangci-lint \
    -m rootfs=${MATRIX_ROOTFS} \
    -m kernel=${MATRIX_KERNEL} \
    -m arch=${MATRIX_ARCH}

# ref: https://github.com/golangci/golangci-lint/blob/master/build/Dockerfile
FROM ghcr.io/arhat-dev/base-golang:1.16-${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY golang/golangci-lint/setup.sh /setup.sh
RUN sh /setup.sh && rm -f /setup.sh

ARG MATRIX_KERNEL
ARG MATRIX_ARCH
COPY --from=builder \
    /output/golangci-lint.${MATRIX_KERNEL}.${MATRIX_ARCH}/* \
    /usr/local/bin/
