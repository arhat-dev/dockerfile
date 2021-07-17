#!/bin/sh

set -ex

matrix_rootfs="$1"

case "${matrix_rootfs}" in
debian)
  export DEBIAN_FRONTEND=noninteractive

  apt-get update
  apt-get install -y build-essential git

  rm -rf /var/lib/apt/lists/*
  ;;
alpine)
  apk --no-cache add gcc musl-dev git
  ;;
*)
  echo "Unsupported rootfs ${matrix_rootfs}"
  exit 1
  ;;
esac
