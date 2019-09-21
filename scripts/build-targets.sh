#!/bin/sh

set -e

. scripts/env.sh

# use gnu grep on macOS, fallback to grep on linux
GREP=$(which ggrep || which grep)

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
  domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^base-')"
}

builder() {
  domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^builder-')"
}

container() {
  domake "$(echo "$ALL_TARGETS" | $GREP -P -e '^(?!(push|base|builder|images|Makefile|app))')"
}

app() {
  local APPS="caddy v2ray"
  local ARCH_SET="amd64 arm64 armv7 armv6"

  for a in ${APPS}; do
    local APP=${a#app-}
    local IMAGE_NAME="${DOCKER_REPO}/${APP}"

    for ARCH in ${ARCH_SET}; do
      ./scripts/app.sh ${APP} ${ARCH}
      
      ./scripts/manifest.sh create ${IMAGE_NAME} ${ARCH} latest
      ./scripts/manifest.sh annotate ${IMAGE_NAME} ${ARCH} latest ${ARCH}
    done

    ./scripts/manifest.sh push ${IMAGE_NAME} latest
  done
}

"$@"
