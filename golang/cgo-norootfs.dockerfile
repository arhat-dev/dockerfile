ARG HOST_ARCH
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:1.16-debian-${HOST_ARCH}-${MATRIX_ARCH} AS builder

ARG APP
ARG MATRIX_KERNEL
ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build \
  ${APP} \
  -m kernel=${MATRIX_KERNEL} \
  -m arch=${MATRIX_ARCH}

FROM scratch

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_KERNEL
ARG MATRIX_ARCH

COPY --from=builder /output/${APP}.${MATRIX_KERNEL}.${MATRIX_ARCH}/* /
