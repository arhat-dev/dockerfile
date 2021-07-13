ARG MATRIX_PYTHON
ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-${MATRIX_PYTHON}:${MATRIX_ROOTFS}-${MATRIX_ARCH} as builder
COPY . /app
RUN sh /build.sh

FROM ghcr.io/arhat-dev/${MATRIX_PYTHON}:${MATRIX_ROOTFS}-${MATRIX_ARCH}
COPY --from=builder /app /app

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile
