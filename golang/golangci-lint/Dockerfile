ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

ARG APP
ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build "${APP}" \
    -m rootfs=${MATRIX_ROOTFS} \
    -m kernel=linux \
    -m arch=${MATRIX_ARCH}

# ref: https://github.com/golangci/golangci-lint/blob/master/build/Dockerfile
FROM ghcr.io/arhat-dev/base-golang:1.16-${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_ARCH
ARG MATRIX_ROOTFS

COPY golang/golangci-lint/setup.sh /setup.sh
RUN sh /setup.sh && rm -f /setup.sh

COPY --from=builder /output/${APP}.linux.${MATRIX_ARCH} /${APP}
