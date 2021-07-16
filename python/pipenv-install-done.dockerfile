ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-python:3.8-${MATRIX_ROOTFS}-${MATRIX_ARCH} as builder
COPY . /app
RUN sh /build.sh

FROM ghcr.io/arhat-dev/python:3.8-${MATRIX_ROOTFS}-${MATRIX_ARCH}
COPY --from=builder /app /app

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile
