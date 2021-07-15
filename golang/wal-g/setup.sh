#!/bin/sh

set -eux

# wal-g build script will download libsodium

case "${MATRIX_ROOTFS:-"debian"}" in
debian)
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y cmake "liblzo2-dev:${DEBIAN_ARCH}"

  rm -rf /var/lib/apt/lists/*
  ;;
alpine)
  apk add --no-cache cmake lzo-dev
  ;;
esac
