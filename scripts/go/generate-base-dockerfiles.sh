#!/bin/sh

. scripts/tools.sh

for go_ver in ${GO_VERSIONS}; do
  for arch in ${DEBIAN_ARCH_LIST}; do
    docker_arch="$(get_docker_arch "${arch}")"
    docker_platform_arch="$(get_docker_platform_arch "${arch}")"

    cat <<EOF > "base/go/debian-${arch}.dockerfile"
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu "${arch}"

FROM --platform=linux/${docker_platform_arch} ${docker_arch}/golang:${go_ver}-${DEBIAN_VERSION}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=downloader /qemu* /usr/bin/

ARG MIRROR_SITE

COPY scripts/go/debian-base-setup.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
  done

  for arch in ${ALPINE_ARCH_LIST}; do
    docker_arch="$(get_docker_arch "${arch}")"
    docker_platform_arch="$(get_docker_platform_arch "${arch}")"

    cat <<EOF > "base/go/alpine-${arch}.dockerfile"
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu "${arch}"

FROM --platform=linux/${docker_platform_arch} ${docker_arch}/golang:${go_ver}-alpine${ALPINE_VERSION}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=downloader /qemu* /usr/bin/

COPY scripts/go/alpine-base-setup.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
  done

done
