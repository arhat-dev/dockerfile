ARG ARCH=amd64
FROM arhatdev/base-go:alpine-${ARCH}

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ ! -z "${TARGET}" ]; then \
    make ${TARGET} ;\
  fi
