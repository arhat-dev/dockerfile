#!/bin/sh

set -ex

# MIRROR_SITE="${MIRROR_SITE}"

# add multiarchs
dpkg --add-architecture amd64
dpkg --add-architecture armhf
dpkg --add-architecture armel
dpkg --add-architecture i386
dpkg --add-architecture mips
dpkg --add-architecture mipsel
dpkg --add-architecture mips64el
dpkg --add-architecture ppc64el
dpkg --add-architecture ppc64
dpkg --add-architecture riscv64

sed -i 's/^deb\b/& [arch=amd64,i386,arm64,armhf,armel,mips,mipsel,mips64el,ppc64el,s390x]/g' /etc/apt/sources.list

if [ -n "${MIRROR_SITE}" ]; then
  sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list
  sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list
fi

wget -qO- https://www.ports.debian.org/archive_2021.key | apt-key add -

cat <<EOF >> /etc/apt/sources.list
deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports unstable main
deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports unreleased main
deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports experimental main
EOF

apt-get update
apt-get upgrade -y

apt-get update
# arm cross compiler
apt-get install -y --no-install-recommends \
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi linux-libc-dev-armel-cross \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf linux-libc-dev-armhf-cross

# NOTE: native: gcc-aarch64-linux-gnu g++-aarch64-linux-gnu linux-libc-dev-arm64-cross

# mips cross compiler
apt-get install -y --no-install-recommends \
    gcc-mips-linux-gnu g++-mips-linux-gnu linux-libc-dev-mips-cross \
    gcc-mipsel-linux-gnu g++-mipsel-linux-gnu linux-libc-dev-mipsel-cross \
    gcc-mips64-linux-gnuabi64 g++-mips64-linux-gnuabi64 linux-libc-dev-mips64-cross \
    gcc-mips64el-linux-gnuabi64 g++-mips64el-linux-gnuabi64 linux-libc-dev-mips64el-cross

# ppc64 cross compiler
apt-get install -y --no-install-recommends \
    gcc-powerpc64-linux-gnu g++-powerpc64-linux-gnu linux-libc-dev-ppc64-cross \
    gcc-powerpc64le-linux-gnu g++-powerpc64le-linux-gnu linux-libc-dev-ppc64el-cross

# other
apt-get install -y --no-install-recommends \
    gcc-i686-linux-gnu g++-i686-linux-gnu linux-libc-dev-i386-cross \
    gcc-riscv64-linux-gnu g++-riscv64-linux-gnu linux-libc-dev-riscv64-cross \
    gcc-s390x-linux-gnu g++-s390x-linux-gnu linux-libc-dev-s390x-cross

apt-get install -y --no-install-recommends \
    git make curl wget
