#!/bin/sh

set -eux

# requires build-arg MATRIX_ARCH TINI_VERSION

tini_arch=""

case "${MATRIX_ARCH}" in
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
  tini_arch=${MATRIX_ARCH}
  ;;
*)
  echo "Unsupported arch ${MATRIX_ARCH} for tini"
  exit 1
  ;;
esac

TINI_BIN="tini-static-${tini_arch}"

curl --retry 10 -S -L -O \
  "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/${TINI_BIN}"

curl --retry 10 -S -L -O \
  "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/${TINI_BIN}.sha256sum"

sha256sum -c "${TINI_BIN}.sha256sum"

rm "${TINI_BIN}.sha256sum"
mv "${TINI_BIN}" /bin/tini

chmod +x /bin/tini

echo "tini installed to /bin/tini"
