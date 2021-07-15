#!/bin/sh

set -eux

case "${MATRIX_ROOTFS}" in
debian)
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y \
    cmake=3.13.4-1 \
    libsodium-dev=1.0.17-1 \
    liblzo2-dev=2.10-0.1

  rm -rf /var/lib/apt/lists/*
  ;;
alpine)
  apk add --no-cache cmake libsodium-dev
  ;;
esac
