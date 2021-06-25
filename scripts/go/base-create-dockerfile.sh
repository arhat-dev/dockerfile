#!/bin/sh

docker_platform_arch="${1}"

if [ "${MATRIX_ARCH}" = "amd64" ]; then
  exit 0
fi

go_version="${MATRIX_LANGUAGE#go}"
suffix=""

case "${MATRIX_ROOTFS}" in
debian)
  suffix="${DEBIAN_VERSION}"
  ;;
alpine)
  suffix="alpine${ALPINE_VERSION}"
  ;;
*)
  echo "Unknown rootfs ${MATRIX_ROOTFS}"
  exit 1
  ;;
esac

cat <<EOF >"base/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu "${MATRIX_ARCH}"

FROM --platform=linux/${docker_platform_arch} docker.io/library/golang:${go_version}-${suffix}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=downloader /qemu* /usr/bin/

ARG MIRROR_SITE

COPY scripts/go/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
