#!/bin/sh

cat <<EOF > "builder/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM ghcr.io/arhat-dev/base-${MATRIX_LANGUAGE}:${MATRIX_ROOTFS}-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ENV PIPENV_VENV_IN_PROJECT 1

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \\
  if [ -n "\${TARGET}" ]; then \\
    pipenv install ;\\
  fi ; \\
  find /usr/local -depth \\
		\\( \\
			\\( -type d -a \\( -name test -o -name tests \\) \\) \\
			-o \\
			\\( -type f -a \\( -name '*.pyc' -o -name '*.pyo' \\) \\) \\
		\\) -exec rm -rf '{}' + ;\\
  find /app -depth \\
		\\( \\
			\\( -type d -a \\( -name test -o -name tests \\) \\) \\
			-o \\
			\\( -type f -a \\( -name '*.pyc' -o -name '*.pyo' \\) \\) \\
		\\) -exec rm -rf '{}' + ;
EOF
