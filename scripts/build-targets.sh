#!/bin/sh

set -e

. scripts/env.sh

# use gnu grep on macOS, fallback to grep on linux
GREP=$(command -v ggrep || command -v grep)

ALL_TARGETS=$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u)

domake() {
  local RECIPES="$1"
  echo "-----------------Targets-----------------"
  echo "${RECIPES}"
  echo "---------------Build-Start---------------"
  for r in ${RECIPES}; do
    echo "make $r"
    make "$r"
  done
}

base() {
  domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^base' | $GREP -E -e "$1")"
}

builder() {
  domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^builder' | $GREP -E -e "$1")"
}

container() {
  domake "$(echo "$ALL_TARGETS" | $GREP -P -e '^(?!(push|base|builder|images|Makefile|app))' | $GREP -E -e "$1")"
}

_build_app_image() {
  local app="${1}"
  local arch_set="${2}"
  local image_names=""

  for repo in ${IMAGE_REPOS}; do
    image_names="${repo}/$(printf '%s' "${app}" | sed -e 's/\_/\-/g') ${image_names}"
  done

  for arch in ${arch_set}; do
    ./scripts/app/image.sh "${app}" "${arch}"

    for name in ${image_names}; do
      docker push "${name}:${arch}"

      ./scripts/manifest.sh create "${name}" "${arch}" latest
      ./scripts/manifest.sh annotate "${name}" "${arch}" latest "${arch}"
    done
  done

  for name in ${image_names}; do
    ./scripts/manifest.sh push "${name}" latest
  done
}

app() {
  _build_app_image helms3 "amd64 arm64 armv7 armv6"
  _build_app_image kubeval "amd64 arm64 armv7 armv6"
  # _build_app_image conftest "amd64 arm64 armv7 armv6"
  _build_app_image helm "amd64 arm64 armv7"

  _build_app_image github_runner "amd64 arm64 armv7"
  _build_app_image hydroxide "amd64 arm64 armv7 armv6"
  _build_app_image frp "amd64 arm64 armv7"
  _build_app_image v2ray "amd64 arm64 armv7 armv6"
  _build_app_image caddy "amd64 arm64 armv7 armv6"
}

"$@"
