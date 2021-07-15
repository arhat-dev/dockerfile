ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:${MATRIX_ROOTFS}-${MATRIX_ARCH} AS builder

ARG MATRIX_ARCH
ARG MATRIX_ROOTFS
ARG APP

COPY . /app
RUN dukkha golang local build -v verbose \
  ${APP} \
  -m kernel=linux \
  -m arch=${MATRIX_ARCH} \
  -m rootfs=${MATRIX_ROOTFS}

FROM ghcr.io/arhat-dev/golang:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
ARG MATRIX_ROOTFS
ARG APP
COPY --from=builder /app/build/${APP}.linux.${MATRIX_ROOTFS}.${MATRIX_ARCH} /${APP}
