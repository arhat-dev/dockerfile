#!/bin/sh

set -eux

matrix_rootfs="$1"
# matrix_arch="$2"

# rootfs_host_arch="$3"

# if [ -n "${MIRROR_SITE}" ]; then
#   sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list
#   sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list
# fi

setup_debian() {
  export DEBIAN_FRONTEND=noninteractive

  apt-get update
  apt-get install -y apt-transport-https
  sed -i 's/http:/https:/g' /etc/apt/sources.list

  apt-get update
  apt-get upgrade -y
  apt-get install -y --no-install-recommends \
    git make cmake curl build-essential wget ca-certificates unzip

  rm -rf /var/lib/apt/lists/*
}

setup_alpine() {
  apk update
  apk add --no-cache \
    git make cmake curl build-base wget bash ca-certificates unzip

  rm -rf /var/cache/apk/*
}

case "${matrix_rootfs}" in
debian)
  setup_debian
  ;;
alpine)
  setup_alpine
  ;;
esac
