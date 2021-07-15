#!/bin/sh

set -eux

cross_arch="$2"

case "${cross_arch}" in
armv5 | armv6)
  rustup target add arm-unknown-linux-gnueabi
  rustup target add arm-unknown-linux-musleabi
  ;;
armv7)
  rustup target add armv7-unknown-linux-gnueabihf
  rustup target add armv7-unknown-linux-musleabihf
  ;;
arm64)
  rustup target add aarch64-unknown-linux-gnu
  rustup target add aarch64-unknown-linux-musl
  ;;
amd64)
  rustup target add x86_64-unknown-linux-gnu
  rustup target add x86_64-unknown-linux-musl
  ;;
mips | mipshf)
  rustup target add mips-unknown-linux-gnu
  rustup target add mips-unknown-linux-musl
  ;;
mipsle | mipslehf)
  rustup target add mipsel-unknown-linux-gnu
  rustup target add mipsel-unknown-linux-musl
  ;;
mips64 | mips64hf)
  rustup target add mips64-unknown-linux-gnuabi64
  ;;
mips64le | mips64lehf)
  rustup target add mips64el-unknown-linux-gnuabi64
  ;;
ppc)
  rustup target add powerpc-unknown-linux-gnu
  ;;
ppc64)
  rustup target add powerpc64-unknown-linux-gnu
  ;;
ppc64le)
  rustup target add powerpc64le-unknown-linux-gnu
  ;;
s390x)
  rustup target add s390x-unknown-linux-gnu
  ;;
esac

