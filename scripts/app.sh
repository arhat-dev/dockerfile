#!/bin/sh

set -e

. scripts/env.sh

v2ray() {
  local ARCH=$1

  docker build -f app/v2ray.dockerfile \
    -t "${DOCKER_REPO}/v2ray:${ARCH}" \
    --build-arg ARCH="${ARCH}" .
}

caddy() {
  local ARCH=$1
  local GOARCH=$1
  local GOARM=7

  case "${ARCH}" in
    armv*) 
      GOARCH=arm
      GOARM=${ARCH#armv}
      ;;
  esac

  docker build -f app/caddy.dockerfile \
    -t "${DOCKER_REPO}/v2ray:${ARCH}" \
    --build-arg ARCH="${ARCH}" \
    --build-arg GOARCH="${GOARCH}" \
    --build-arg GOARM="${GOARM}" .
}

"$@"
