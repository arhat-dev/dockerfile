#!/bin/sh

set -eux

matrix_rootfs="$1"
matrix_arch="$2"
matrix_cross_arch="$3"
matrix_rootfs_version="$4"

rootfs_host_arch="$5"
rootfs_cross_arch="$6"
rootfs_cross_triple_name="$7"

install_debian_cross_toolchain() {
  apt-get install -y --no-install-recommends \
    "gcc-${rootfs_cross_triple_name}" \
    "g++-${rootfs_cross_triple_name}" \
    "linux-libc-dev-${rootfs_cross_arch}-cross"
}

setup_debian() {
  case "${rootfs_cross_arch}" in
  ppc64 | riscv64)
    wget -qO- https://www.ports.debian.org/archive_2021.key | apt-key add -

    cat <<EOF >>/etc/apt/sources.list
deb [arch=${rootfs_cross_arch}] http://ftp.ports.debian.org/debian-ports unstable main
deb [arch=${rootfs_cross_arch}] http://ftp.ports.debian.org/debian-ports unreleased main
deb [arch=${rootfs_cross_arch}] http://ftp.ports.debian.org/debian-ports experimental main
EOF
    ;;
  *)
    dpkg --add-architecture "${rootfs_cross_arch}"
    sed -i "s/^deb\\b/& [arch=${rootfs_host_arch},${rootfs_cross_arch}]/g" /etc/apt/sources.list
    ;;
  esac

  cat /etc/apt/sources.list

  # if [ -n "${MIRROR_SITE}" ]; then
  #   sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list
  #   sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list
  # fi

  export DEBIAN_FRONTEND=noninteractive

  apt-get update
  apt-get upgrade -y

  apt-get update
  apt-get install -y --no-install-recommends \
    git \
    make \
    build-essential \
    xz-utils \
    musl-tools \
    curl \
    wget \
    ca-certificates

  # Install cross compiler

  # check host arch
  case "${matrix_arch}" in
  amd64)
    # check target arch if
    case "${matrix_cross_arch}" in
    armv7)
      # add arm cross compiler from linaro
      curl --retry 10 -o arm-none-linux-gnueabihf.tar.xz -sSfL \
        https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
      tar xf arm-none-linux-gnueabihf.tar.xz
      mv gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf /opt/arm-none-linux-gnueabihf
      rm -rf arm-none-linux-gnueabihf.tar.xz
      ;;
    arm64)
      # add arm64 cross compiler from linaro
      curl --retry 10 -o aarch64-none-linux-gnu.tar.xz -sSfL \
        https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz
      tar xf aarch64-none-linux-gnu.tar.xz
      mv gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu /opt/aarch64-none-linux-gnu
      rm -rf aarch64-none-linux-gnu.tar.xz
      ;;
    esac

    # all cross toolchain are available for amd64
    install_debian_cross_toolchain
    ;;
  arm64)
    case "${matrix_rootfs_version}" in
    buster | 10 | 10.*)
      # toolchain for arm64 in buster is limited to arm and x86
      # (more available in bullseye)
      case "${matrix_cross_arch}" in
      x86 | arm*)
        install_debian_cross_toolchain
        ;;
      esac
      ;;
    bullseye | 11 | 11.*)
      # most toolchains are available for arm64 in bullseye
      install_debian_cross_toolchain
      ;;
    esac
    ;;
  esac

  rm -rf /var/lib/apt/lists/*
}

setup_alpine() {
  # alpine has no multi-arch support
  :
}

case "${matrix_rootfs}" in
debian)
  setup_debian
  ;;
alpine)
  setup_alpine
  ;;
esac
