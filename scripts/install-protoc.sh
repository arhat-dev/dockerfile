#!/bin/sh

set -eux

protoc_arch=""
case "${MATRIX_ARCH}" in
arm64)
  protoc_arch="aarch_64"
  ;;
ppc64le)
  protoc_arch="ppcle_64"
  ;;
s390x)
  protoc_arch="s390_64"
  ;;
amd64)
  protoc_arch="x86_64"
  ;;
*)
  echo "Unsupported protoc arch ${MATRIX_ARCH}"
  exit 1
  ;;
esac

filename="protoc-${PROTOC_VERSION}-linux-${protoc_arch}"
base_url="https://github.com/protocolbuffers/protobuf/releases/download/${PROTOC_VERSION}"
download_url="${base_url}/${filename}.zip"
