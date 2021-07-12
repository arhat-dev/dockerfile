#!/bin/sh

set -ex

case "${MATRIX_ROOTFS}" in
debian)
  apt-get update
  apt-get install -y build-essential python3
  ;;
alpine)
  apk add --no-cache build-base python3
  ;;
*)
  echo "Unsupported rootfs ${MATRIX_ROOTFS}"
  exit 1
  ;;
esac

npm install -g node-gyp
npm i re2 --save
