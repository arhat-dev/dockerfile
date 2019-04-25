FROM arhatdev/base-go:latest

WORKDIR /arhat

ONBUILD COPY . /arhat
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ ! -z "${TARGET}" ]; then \
    make ${TARGET} ;\
  fi
