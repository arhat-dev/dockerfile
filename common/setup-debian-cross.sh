#!/bin/sh

set -eux

host_arch="$1"
cross_arch="$2"
cross_triple_name="$3"

case "${cross_arch}" in
ppc64 | riscv64)
  wget -qO- https://www.ports.debian.org/archive_2021.key | apt-key add -

  cat <<EOF >>/etc/apt/sources.list
deb [arch=${cross_arch}] http://ftp.ports.debian.org/debian-ports unstable main
deb [arch=${cross_arch}] http://ftp.ports.debian.org/debian-ports unreleased main
deb [arch=${cross_arch}] http://ftp.ports.debian.org/debian-ports experimental main
EOF
  ;;
*)
  dpkg --add-architecture "${cross_arch}"
  sed -i "s/^deb\\b/& [arch=${host_arch},${cross_arch}]/g" /etc/apt/sources.list
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

case "${cross_arch}" in
armhf)
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
*)
  apt-get install -y --no-install-recommends \
    "gcc-${cross_triple_name}" \
    "g++-${cross_triple_name}" \
    "linux-libc-dev-${cross_arch}-cross"
  ;;
esac

rm -rf /var/lib/apt/lists/*
