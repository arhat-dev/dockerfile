FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

ARG MATRIX_KERNEL
ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build \
      sonar-badge-proxy \
      -m kernel=${MATRIX_KERNEL} \
      -m arch=${MATRIX_ARCH}

FROM scratch

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_KERNEL
ARG MATRIX_ARCH

COPY --from=builder /output/sonar-badge-proxy.${MATRIX_KERNEL}.${MATRIX_ARCH}/sonar-badge-proxy /sonar-badge-proxy
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

ENTRYPOINT [ "/sonar-badge-proxy" ]
