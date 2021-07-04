#!/bin/sh

set -ex

# MIRROR_SITE="${MIRROR_SITE}"

# add multiarchs
dpkg --add-architecture armhf
dpkg --add-architecture armel
dpkg --add-architecture arm64
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
apt-get install -y --no-install-recommends \
    git make curl wget musl-tools xz-utils build-essential

# https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads

# add arm cross compiler
curl -o arm-none-linux-gnueabihf.tar.xz -sSfL \
  https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
tar xf arm-none-linux-gnueabihf.tar.xz
mv gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf /opt/arm-none-linux-gnueabihf
rm -rf arm-none-linux-gnueabihf.tar.xz

# add arm64 cross compiler
curl -o aarch64-none-linux-gnu.tar.xz -sSfL \
  https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz
tar xf aarch64-none-linux-gnu.tar.xz
mv gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu /opt/aarch64-none-linux-gnu
rm -rf aarch64-none-linux-gnu.tar.xz

# arm cross compiler
apt-get install -y --no-install-recommends \
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi linux-libc-dev-armel-cross

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

# add cross compile targets
rustup target add arm-unknown-linux-gnueabi
rustup target add armv7-unknown-linux-gnueabihf
rustup target add aarch64-unknown-linux-gnu
rustup target add x86_64-unknown-linux-gnu
#   rustup target add mips-unknown-linux-gnu
#   rustup target add mipsel-unknown-linux-gnu
#   rustup target add mips64-unknown-linux-gnuabi64
#   rustup target add mips64el-unknown-linux-gnuabi64
#   rustup target add powerpc-unknown-linux-gnu
#   rustup target add powerpc64-unknown-linux-gnu
#   rustup target add powerpc64le-unknown-linux-gnu
#   rustup target add s390x-unknown-linux-gnu

# musl libc
rustup target add arm-unknown-linux-musleabi
rustup target add armv7-unknown-linux-musleabihf
rustup target add aarch64-unknown-linux-musl
rustup target add x86_64-unknown-linux-musl

# rustup target add mips-unknown-linux-musl
# rustup target add mipsel-unknown-linux-musl
