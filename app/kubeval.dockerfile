ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-go:${MATRIX_ROOTFS} AS builder

ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build kubeval -m kernel=linux -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/go:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
COPY --from=builder /app/build/kubeval.linux.${MATRIX_ARCH} /kubeval
