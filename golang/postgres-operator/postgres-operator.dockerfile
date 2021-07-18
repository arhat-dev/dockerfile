ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

ARG MATRIX_KERNEL
ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build \
      postgres-operator \
      -m kernel=${MATRIX_KERNEL} \
      -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/golang:1.16-${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_KERNEL
ARG MATRIX_ARCH
COPY --from=builder \
      /output/postgres-operator.${MATRIX_KERNEL}.${MATRIX_ARCH}/postgres-operator \
      /usr/local/bin/postgres-operator

ARG MATRIX_ROOTFS
RUN set -eux ;\
    if [ "${MATRIX_ROOTFS}" = "debian" ]; then \
      export DEBIAN_FRONTEND=noninteractive ;\
      apt-get update ;\
      apt-get install -y ca-certificates curl ;\
      rm -rf /var/lib/apt/lists/* ;\
    elif [ "${MATRIX_ROOTFS}" = "alpine" ]; then \
      apk --no-cache add ca-certificates curl ;\
      rm -rf /var/cache/apk/* ;\
    else \
      echo "Unsupported rootfs ${MATRIX_ROOTFS}" ;\
      exit 1 ;\
    fi

ENTRYPOINT ["/postgres-operator"]
