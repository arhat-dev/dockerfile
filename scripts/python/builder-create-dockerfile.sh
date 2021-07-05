#!/bin/sh

cat <<EOF > "builder/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
ARG DUKKHA_IMAGE
ARG BASE_IMAGE

FROM \${DUKKHA_IMAGE} as dukkha
FROM \${BASE_IMAGE}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ENV PIPENV_VENV_IN_PROJECT 1

WORKDIR /app
COPY --from=dukkha /dukkha /usr/local/bin/dukkha
RUN chmod +x /usr/local/bin/dukkha

COPY scripts/${MATRIX_LANGUAGE}/build.sh /build.sh
EOF
