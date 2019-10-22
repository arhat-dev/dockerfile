#!/bin/sh

set -e

. scripts/env.sh

v2ray() {
  local arch="$1"

  docker build -f app/v2ray.dockerfile \
    $(get_tag_args v2ray:${arch}) \
    --build-arg ARCH="${arch}" .
}

caddy() {
  local arch="$1"
  local GOARCH="$1"
  local GOARM=7

  case "${arch}" in
    armv*) 
      GOARCH=arm
      GOARM=${arch#armv}
      ;;
  esac

  docker build -f app/caddy.dockerfile \
    $(get_tag_args caddy:${arch}) \
    --build-arg TARGET="caddy-linux-${arch}" \
    --build-arg APP="caddy" \
    --build-arg ARCH="${arch}" \
    --build-arg GOARCH="${GOARCH}" \
    --build-arg GOARM="${GOARM}" .
}

frp() {
  local arch=$1

  docker build -f app/frp.dockerfile \
    $(get_tag_args frp:${arch}) \
    --build-arg ARCH="${arch}" .
}

"$@"
