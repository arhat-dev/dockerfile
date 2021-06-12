ARG ARCH=amd64
FROM ghcr.io/arhat-dev/base-go:debian-${ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ -n "${TARGET}" ]; then \
    make ${TARGET} ;\
  fi
