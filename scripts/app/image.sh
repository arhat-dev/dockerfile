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

athens() {
  arch="$1"
  
  git clone https://github.com/athensresearch/athens.git app/athens
  docker build -f app/athens/Dockerfile \
    $(get_tag_args "athens:${arch}") \
    app/athens
}

"$@"
