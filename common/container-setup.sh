#!/bin/sh

set -eux

# requires build-arg TINI_VERSION

matrix_rootfs="$1"
matrix_arch="$2"

# rootfs_host_arch="$3"

install_tini() {
  tini_arch=""

  case "${matrix_arch}" in
  armv5 | armv6)
    tini_arch=armel
    ;;
  armv7)
    tini_arch=armhf
    ;;
  x86)
    tini_arch=i386
    ;;
  mips64le)
    tini_arch=mips64el
    ;;
  ppc64le)
    tini_arch=ppc64el
    ;;
  arm64 | amd64 | s390x)
    tini_arch=${matrix_arch}
    ;;
  *)
    echo "Unsupported arch ${matrix_arch} for tini"
    exit 1
    ;;
  esac

  tini_bin="tini-static-${tini_arch}"

  curl --retry 10 -S -L -O \
    "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/${tini_bin}"

  curl --retry 10 -S -L -O \
    "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/${tini_bin}.sha256sum"

  sha256sum -c "${tini_bin}.sha256sum"

  rm "${tini_bin}.sha256sum"
  mv "${tini_bin}" /bin/tini

  chmod +x /bin/tini

  echo "tini installed to /bin/tini"
}

case "${matrix_rootfs}" in
debian)
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y curl

  install_tini

  apt-get autoremove -y curl

  rm -rf /var/lib/apt/lists/*
  ;;
alpine)
  apk add --no-cache --virtual .fetch-deps curl

  install_tini

  apk del --purge .fetch-deps
  ;;
esac
