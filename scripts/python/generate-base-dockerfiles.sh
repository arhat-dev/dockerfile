#!/bin/sh

. scripts/tools.sh

for py_version in ${PYTHON_VERSIONS}; do

  for arch in ${DEBIAN_ARCH_LIST}; do
    docker_arch="$(get_docker_arch "${arch}")"
    docker_platform_arch="$(get_docker_platform_arch "${arch}")"

    cat <<EOF > "base/python${py_version}/debian-${arch}.dockerfile"
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu "${arch}"

FROM --platform=linux/${docker_platform_arch} ${docker_arch}/python:${py_version}-${DEBIAN_VERSION}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=downloader /qemu* /usr/bin/

COPY scripts/python/debian-base-setup.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
  done

  for arch in ${ALPINE_ARCH_LIST}; do
    docker_arch="$(get_docker_arch "${arch}")"
    docker_platform_arch="$(get_docker_platform_arch "${arch}")"

    cat <<EOF > "base/python${py_version}/alpine-${arch}.dockerfile"
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu "${arch}"

FROM --platform=linux/${docker_platform_arch} ${docker_arch}/python:${py_version}-alpine${ALPINE_VERSION}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=downloader /qemu* /usr/bin/

COPY scripts/python/alpine-base-setup.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
  done

done
