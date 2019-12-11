#!/bin/sh

set -e

. scripts/env.sh

v2ray() {
  local arch="$1"

  docker build -f app/v2ray.dockerfile \
    $(get_tag_args "v2ray:${arch}") \
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
    $(get_tag_args "caddy:${arch}") \
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

hydroxide() {
  local arch="$1"

  docker build -f app/hydroxide.dockerfile \
    $(get_tag_args hydroxide:${arch}) \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="hydroxide-linux-${arch}" \
    --build-arg APP="hydroxide" .
}

github_runner() {
  local arch="$1"
  local docker_arch="${arch}"

  case "${arch}" in
    armv*)
      docker_arch="arm32v${arch#armv}"
      ;;
    arm64)
      docker_arch="arm64v8"
      ;;
  esac

  docker build -f app/github-runner.dockerfile \
    $(get_tag_args "github-runner:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg DOCKER_ARCH="${docker_arch}" .
}

kubeval() {
  local arch="$1"

  docker build -f app/kubeval.dockerfile \
    $(get_tag_args "kubeval:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="kubeval-linux-${arch}" \
    --build-arg APP="kubeval" .
}

conftest() {
  local arch="$1"

  docker build -f app/conftest.dockerfile \
    $(get_tag_args "conftest:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="conftest-linux-${arch}" \
    --build-arg APP="conftest" .
}

helm() {
  local arch="$1"

  docker build -f app/helm.dockerfile \
    $(get_tag_args "helm:${arch}") \
    --build-arg ARCH="${arch}" \
    --build-arg TARGET="helm-linux-${arch}" \
    --build-arg APP="helm" .
}

"$@"
