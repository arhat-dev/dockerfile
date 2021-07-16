# https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitlab-exporter/Dockerfile
ARG MATRIX_ROOTFS
ARG HOST_ARCH
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-ruby:2.7-${MATRIX_ROOTFS}-${HOST_ARCH}-${MATRIX_ARCH} AS builder

ARG MATRIX_ARCH
ARG APP

COPY . /app
RUN dukkha golang local build \
  "${APP}" \
  -m kernel=linux \
  -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/ruby:2.7-${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_KERNEL
ARG MATRIX_ARCH
COPY --from=builder /output/${APP}.${MATRIX_KERNEL}.${MATRIX_ARCH}/* /
