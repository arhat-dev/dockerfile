#!/bin/sh

set -e

GO_VERSIONS="1.16"
PYTHON_VERSIONS="3.6 3.7 3.8 3.9"

DEBIAN_VERSION="buster"
ALPINE_VERSION="3.12"

DEBIAN_ARCH_LIST="arm64 armv5 armv7 mips64le ppc64le s390x x86"
ALPINE_ARCH_LIST="arm64 armv6 armv7 ppc64le s390x x86"

get_docker_arch() {
  case "$1" in
    arm64)
      printf "arm64v8"
    ;;
    armv5)
    printf "arm32v5"
    ;;
    armv6)
      printf "arm32v6"
      ;;
    armv7)
      printf "arm32v7"
      ;;
    s390x)
      printf "s390x"
      ;;
    ppc64le)
      printf "ppc64le"
      ;;
    x86)
      printf "i386"
      ;;
    mips64le)
      printf "mips64le"
      ;;
    *)
      echo "ERROR: unknown arch $1" >&2
      return 1
      ;;
  esac
}
