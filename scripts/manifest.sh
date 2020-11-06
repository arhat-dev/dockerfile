#!/bin/sh

set -e

create() {
  image_name=$1
  image_tag=$2
  manifest_tag=$3

  docker manifest create "${image_name}:${manifest_tag}" "${image_name}:${image_tag}" || \
    docker manifest create "${image_name}:${manifest_tag}" --amend "${image_name}:${image_tag}" || true
}

annotate() {
  image_name=$1
  image_tag=$2
  manifest_tag=$3
  arch=$4
  manifest_arch=${arch}
  manifest_arch_variant=""

  case "${arch}" in
    armv*)
      manifest_arch=arm
      manifest_arch_variant=${arch#armv}
    ;;
  esac

  args="--arch ${manifest_arch} --os linux"
  if [ -n "${manifest_arch_variant}" ]; then
    args="${args} --variant ${manifest_arch_variant}"
  fi

  docker manifest annotate "${image_name}:${manifest_tag}" "${image_name}:${image_tag}" ${args} || true
}

push() {
  image_name=$1
  manifest_tag=$2

  docker manifest push "${image_name}:${manifest_tag}" || true
}

"$@"
