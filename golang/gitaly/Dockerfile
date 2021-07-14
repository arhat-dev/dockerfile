ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-go:${MATRIX_ROOTFS}-${MATRIX_ARCH} AS builder

ARG PROTOC_VERSION
COPY scripts/install-protoc.sh /install-protoc.sh
# always install amd64 version of protoc, run in qemu
RUN MATRIX_ARCH="amd64" \
    sh /install-protoc.sh && rm -f /install-protoc.sh

ARG MATRIX_ARCH
ARG MATRIX_ROOTFS
ARG APP

COPY . /app
RUN dukkha golang local build -v verbose \
  ${APP} \
  -m kernel=linux \
  -m arch=${MATRIX_ARCH} \
  -m rootfs=${MATRIX_ROOTFS}

FROM ghcr.io/arhat-dev/go:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
ARG MATRIX_ROOTFS
ARG APP
COPY --from=builder /app/build/${APP}.linux.${MATRIX_ROOTFS}.${MATRIX_ARCH} /${APP}
