ARG HOST_ARCH
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:1.16-debian-${HOST_ARCH}-${MATRIX_ARCH} AS builder

ARG MATRIX_ARCH
ARG APP

COPY . /app
RUN dukkha golang local build \
  ${APP} \
  -m kernel=linux \
  -m arch=${MATRIX_ARCH}

FROM scratch

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_KERNEL
ARG MATRIX_ARCH
ARG APP
COPY --from=builder /output/${APP}.${MATRIX_KERNEL}.${MATRIX_ARCH}/* /
