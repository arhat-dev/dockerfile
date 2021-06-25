#!/bin/sh

docker_platform_arch="${1}"
go_version="${MATRIX_LANGUAGE#go}"
suffix=""

case "${MATRIX_ROOTFS}" in
debian)
  suffix="${DEBIAN_VERSION}"
  ;;
alpine)
  suffix="alpine${ALPINE_VERSION}"
  ;;
*)
  echo "Unknown rootfs ${MATRIX_ROOTFS}"
  exit 1
  ;;
esac

base_image="docker.io/library/golang:${go_version}-${suffix}"

if [ "${MATRIX_ARCH}" = "amd64" ]; then
  case "${MATRIX_ROOTFS}" in
    debian)
      cat <<EOF
FROM --platform=linux/amd64 ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MIRROR_SITE

# add multiarchs
RUN set -e;\
    dpkg --add-architecture armhf ;\
    dpkg --add-architecture armel ;\
    dpkg --add-architecture arm64 ;\
    dpkg --add-architecture i386 ;\
    dpkg --add-architecture mips ;\
    dpkg --add-architecture mipsel ;\
    dpkg --add-architecture mips64el ;\
    dpkg --add-architecture ppc64el ;\
    dpkg --add-architecture ppc64 ;\
    dpkg --add-architecture riscv64 ;

RUN set -e ;\
    sed -i 's/^deb\b/& [arch=amd64,i386,arm64,armhf,armel,mips,mipsel,mips64el,ppc64el,s390x]/g' /etc/apt/sources.list ;\
    if [ -n "\${MIRROR_SITE}" ]; then \
      sed -i "s/deb.debian.org/\${MIRROR_SITE}/g" /etc/apt/sources.list ;\
      sed -i "s|security.debian.org/debian-security|\${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list ;\
    fi ;

# install dependencies
RUN set -e ;\
    wget -qO- https://www.ports.debian.org/archive_2021.key | apt-key add - ;\
    echo "deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports unstable main" >> /etc/apt/sources.list ;\
    echo "deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports unreleased main" >> /etc/apt/sources.list ;\
    echo "deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports experimental main" >> /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;

RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
    # arm cross compiler
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi linux-libc-dev-armel-cross \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf linux-libc-dev-armhf-cross \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu linux-libc-dev-arm64-cross \
    # # mips cross compiler
    gcc-mips-linux-gnu g++-mips-linux-gnu linux-libc-dev-mips-cross \
    gcc-mipsel-linux-gnu g++-mipsel-linux-gnu linux-libc-dev-mipsel-cross \
    gcc-mips64-linux-gnuabi64 g++-mips64-linux-gnuabi64 linux-libc-dev-mips64-cross \
    gcc-mips64el-linux-gnuabi64 g++-mips64el-linux-gnuabi64 linux-libc-dev-mips64el-cross \
    # # ppc64 cross compiler
    gcc-powerpc64-linux-gnu g++-powerpc64-linux-gnu linux-libc-dev-ppc64-cross \
    gcc-powerpc64le-linux-gnu g++-powerpc64le-linux-gnu linux-libc-dev-ppc64el-cross \
    # # other
    gcc-i686-linux-gnu g++-i686-linux-gnu linux-libc-dev-i386-cross \
    gcc-riscv64-linux-gnu g++-riscv64-linux-gnu linux-libc-dev-riscv64-cross \
    gcc-s390x-linux-gnu g++-s390x-linux-gnu linux-libc-dev-s390x-cross \
    # tools
    git make curl wget;

EOF
      exit 0
    ;;
    alpine)
      cat <<EOF
FROM --platform=linux/amd64 ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY scripts/${MATRIX_LANGUAGE}/base-setup-alpine.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
      exit 0
    ;;
  esac
fi

cat <<EOF >"base/${MATRIX_LANGUAGE}/${MATRIX_ROOTFS}-${MATRIX_ARCH}.dockerfile"
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu "${MATRIX_ARCH}"

FROM --platform=linux/${docker_platform_arch} ${base_image}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=downloader /qemu* /usr/bin/

ARG MIRROR_SITE

COPY scripts/${MATRIX_LANGUAGE}/base-setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
EOF
