ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

ARG MATRIX_ARCH
ARG APP

COPY . /app
RUN dukkha golang local build \
  "${APP}" \
  -m kernel=linux \
  -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/golang:1.16-${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_KERNEL
ARG MATRIX_ARCH
COPY --from=builder /app/build/${APP}.${MATRIX_KERNEL}.${MATRIX_ARCH} /${APP}
