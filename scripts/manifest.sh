#!/bin/sh

set -e

create() {
  local IMAGE_REPO=$1
  local IMAGE_TAG=$2
  local MANIFEST_TAG=$3

  docker manifest create "${IMAGE_REPO}:${MANIFEST_TAG}" "${IMAGE_REPO}:${IMAGE_TAG}" || \
    docker manifest create "${IMAGE_REPO}:${MANIFEST_TAG}" --amend "${IMAGE_REPO}:${IMAGE_TAG}"
}

annotate() {
  local IMAGE_REPO=$1
  local IMAGE_TAG=$2
  local MANIFEST_TAG=$3
  local ARCH=$4
  local MANIFEST_ARCH=${ARCH}
  local MANIFEST_ARCH_VARIANT=""

  case "${ARCH}" in
    armv*)
      MANIFEST_ARCH=arm
      MANIFEST_ARCH_VARIANT=${ARCH#armv}
    ;;
  esac

  local ARGS="--arch ${MANIFEST_ARCH} --os linux"
  if [ ! -z "${MANIFEST_ARCH_VARIANT}" ]; then
    ARGS="${ARGS} --variant ${MANIFEST_ARCH_VARIANT}"
  fi

  docker manifest annotate "${IMAGE_REPO}:${MANIFEST_TAG}" "${IMAGE_REPO}:${IMAGE_TAG}" ${ARGS}
}

push() {
  local IMAGE_REPO=$1
  local MANIFEST_TAG=$2

  docker manifest push "${IMAGE_REPO}:${MANIFEST_TAG}"
}

"$@"
