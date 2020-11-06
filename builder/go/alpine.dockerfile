ARG ARCH=amd64
FROM ghcr.io/arhat-dev/base-go:alpine-${ARCH}

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ -n "${TARGET}" ]; then \
    make ${TARGET} ;\
  fi
