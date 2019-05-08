FROM arhatdev/base-go:latest

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ ! -z "${TARGET}" ]; then \
    make ${TARGET} ;\
  fi
