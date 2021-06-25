#!/bin/sh

cat <<EOF > "builder/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM ghcr.io/arhat-dev/base-${MATRIX_LANGUAGE}:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ -n "\${TARGET}" ]; then \
    make \${TARGET} ;\
  fi
EOF
