#!/bin/sh

set -e

create() {
  local IMAGE_NAME=$1
  local IMAGE_TAG=$2
  local MANIFEST_TAG=$3

  docker manifest create "${IMAGE_NAME}:${MANIFEST_TAG}" "${IMAGE_NAME}:${IMAGE_TAG}" || \
    docker manifest create "${IMAGE_NAME}:${MANIFEST_TAG}" --amend "${IMAGE_NAME}:${IMAGE_TAG}"
}

annotate() {
  local IMAGE_NAME=$1
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

  local ARGS="--arch $(MANIFEST_ARCH) --os linux"
  if [ ! -z "${MANIFEST_ARCH_VARIANT}" ]; then
    ARGS="${ARGS} --variant ${MANIFEST_ARCH_VARIANT}"
  fi

  docker manifest annotate "${IMAGE_NAME}:${MANIFEST_TAG}" "${IMAGE_NAME}:${IMAGE_TAG}" ${ARGS}
}

push() {
  local IMAGE_NAME=$1
  local MANIFEST_TAG=$2

  docker manifest push "${IMAGE_NAME}:${MANIFEST_TAG}"
}

"$@"
