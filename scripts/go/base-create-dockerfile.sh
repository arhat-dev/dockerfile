#!/bin/sh

dockerhub_arch="${1}"
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

base_image="docker.io/${dockerhub_arch}/golang:${GO_VERSION}-${suffix}"
dockerfile="base/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"

if [ "${MATRIX_ARCH}" = "amd64" ]; then
  case "${MATRIX_ROOTFS}" in
  debian)
    cat <<EOF >"${dockerfile}"
FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MIRROR_SITE

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}-amd64.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
    exit 0
    ;;
  alpine)
    cat <<EOF >"${dockerfile}"
FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
    exit 0
    ;;
  esac
fi

cat <<EOF >"${dockerfile}"
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu "${MATRIX_ARCH}"

FROM ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=downloader /qemu* /usr/bin/

ARG MIRROR_SITE

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
