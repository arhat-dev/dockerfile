#!/bin/sh

cat <<EOF > "builder/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM ghcr.io/arhat-dev/dukkha:latest-${MATRIX_ARCH} as dukkha
FROM ghcr.io/arhat-dev/base-${MATRIX_LANGUAGE}:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=dukkha /dukkha /usr/local/bin/dukkha
RUN chmod +x /usr/local/bin/dukkha

WORKDIR /app
EOF
