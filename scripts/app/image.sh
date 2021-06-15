#!/bin/sh
# shellcheck disable=SC2046

set -e

. scripts/env.sh

caddy() {
  arch="$1"
  GOARCH="$1"
  GOARM=7

  case "${arch}" in
    armv*)
      GOARCH=arm
      GOARM=${arch#armv}
      ;;
  esac

  docker build -f app/caddy.dockerfile \
    $(get_tag_args "caddy:${arch}") \
    --build-arg TARGET="caddy-linux-${arch}" \
    --build-arg APP="caddy" \
    --build-arg ARCH="${arch}" \
    --build-arg GOARCH="${GOARCH}" \
    --build-arg GOARM="${GOARM}" .
}

hydroxide() {
  arch="$1"

  docker build -f app/hydroxide.dockerfile \
    $(get_tag_args "hydroxide:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="hydroxide-linux-${arch}" \
    --build-arg APP="hydroxide" .
}

kubeval() {
  arch="$1"

  docker build -f app/kubeval.dockerfile \
    $(get_tag_args "kubeval:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="kubeval-linux-${arch}" \
    --build-arg APP="kubeval" .
}

helm() {
  arch="$1"

  docker build -f app/helm.dockerfile \
    $(get_tag_args "helm:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="helm-linux-${arch}" \
    --build-arg APP="helm" .
}

yamllint() {
  arch="$1"

  docker build -f app/yamllint.dockerfile \
    $(get_tag_args "yamllint:${arch}") \
    --build-arg ARCH="${arch}" scripts/app/yamllint
}

spilo() {
  arch="$1"

  mkdir -p .build
  rm -rf .build/spilo

  git clone --depth=1 --branch=2.0-p7 https://github.com/zalando/spilo.git .build/spilo

  docker build -f .build/spilo/postgres-appliance/Dockerfile \
    -t spilo:latest \
    --build-arg TIMESCALEDB=2.3.0 \
    --build-arg ARCH="${arch}" \
    --build-arg BASE_IMAGE="registry.opensource.zalan.do/library/ubuntu-18.04" \
    --build-arg PGVERSION="13" \
    --build-arg PGOLDVERSIONS="9.5 9.6 10 11 12" \
    --build-arg DEMO=false \
    --build-arg TIMESCALEDB_APACHE_ONLY=false \
    .build/spilo/postgres-appliance

  docker build -f app/spilo.dockerfile \
    $(get_tag_args "spilo:${arch}") \
    --build-arg BASE_IMAGE="spilo:latest" .
}

proton_bridge() {
  arch="$1"

  docker build -f app/proton-bridge.dockerfile --no-cache \
    $(get_tag_args "proton-bridge:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="proton-bridge-linux-${arch}" \
    --build-arg APP="proton-bridge" .
}

"$@"
