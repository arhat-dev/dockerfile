#!/bin/sh

set -ex

case "${MATRIX_ROOTFS}" in
debian)
  export DEBIAN_FRONTEND=noninteractive

  apt-get update
  apt-get install -y build-essential git

  rm -rf /var/lib/apt/lists/*
  ;;
alpine)
  apk --no-cache add gcc musl-dev git mercurial
  ;;
*)
  echo "Unsupported rootfs ${MATRIX_ROOTFS}"
  exit 1
  ;;
esac
