#!/bin/sh

set -ex

setup_debian() {
  addgroup --gid 1000 proton-bridge
  adduser --system --home /home/proton \
    --shell "$(which nologin)" \
    --disabled-password \
    --uid 1000 \
    proton-bridge

  adduser proton-bridge proton-bridge

  apt-get update
  apt-get install -y --no-install-recommends \
    expect socat pass ca-certificates

  rm -rf /var/lib/apt/lists/*
}

setup_alpine() {
  addgroup -g 1000 proton-bridge
  adduser -S -h /home/proton \
    -s "$(which nologin)" \
    -D \
    -u 1000 \
    -G proton-bridge \
    proton-bridge

  apk add --no-cache \
    expect socat pass ca-certificates coreutils libnotify
}

case "${MATRIX_ROOTFS}" in
debian)
  setup_debian
  ;;
alpine)
  setup_alpine
  ;;
*)
  echo "Unsupported rootfs"
  exit 1
  ;;
esac

mkdir -p /data
chown -R proton-bridge:proton-bridge /data
