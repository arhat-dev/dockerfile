ARG APP
ARG MATRIX_ARCH

# values like arm64v8
ARG DOCKERHUB_ARCH

# 1.16
ARG GO_VERSION

# buster or alpine
ARG ROOTFS_NAME

# debian or alpine
ARG MATRIX_ROOTFS

FROM ghcr.io/arhat-dev/builder-go:${MATRIX_ROOTFS} AS builder

ARG APP
ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build ${APP} \
    -m rootfs=${MATRIX_ROOTFS} \
    -m kernel=linux \
    -m arch=${MATRIX_ARCH}

# ref: https://github.com/golangci/golangci-lint/blob/master/build/Dockerfile
FROM docker.io/${DOCKERHUB_ARCH}/golang:${GO_VERSION}-${ROOTFS_NAME}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_ARCH
ARG MATRIX_ROOTFS

COPY app/golangci-lint/setup.sh /setup.sh
RUN sh /setup.sh && rm -f /setup.sh

COPY --from=builder /app/build/${APP}.linux.${MATRIX_ARCH} /${APP}
