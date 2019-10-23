FROM golang:buster

ARG MIRROR_SITE

# add multiarchs
RUN set -e;\
    dpkg --add-architecture armhf ;\
    dpkg --add-architecture armel ;\
    dpkg --add-architecture arm64 ;

RUN set -e ;\
    sed -i 's/^deb\b/& [arch=amd64,i386,arm64,armhf,armel,mips,mipsel,mips64el,ppc64el,s390x]/g' /etc/apt/sources.list ;\
    if [ -n "${MIRROR_SITE}" ]; then \
      sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list ;\
      sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list ;\
    fi ;

# install dependencies
RUN set -e ;\
    apt-get update ;\
    apt-get install debian-ports-archive-keyring ;\
    echo "deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports unstable main" >> /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;

RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
    # arm cross compiler
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi linux-libc-dev-armel-cross \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf linux-libc-dev-armhf-cross \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu linux-libc-dev-arm64-cross \
    # # mips cross compiler
    # gcc-mips-linux-gnu g++-mips-linux-gnu linux-libc-dev-mips-cross \
    # gcc-mipsel-linux-gnu g++-mipsel-linux-gnu linux-libc-dev-mipsel-cross \
    # gcc-mips64-linux-gnuabi64 g++-mips64-linux-gnuabi64 linux-libc-dev-mips64-cross \
    # gcc-mips64el-linux-gnuabi64 g++-mips64el-linux-gnuabi64 linux-libc-dev-mips64el-cross \
    # # ppc64 cross compiler
    # gcc-powerpc64-linux-gnu g++-powerpc64-linux-gnu linux-libc-dev-ppc64-cross \
    # gcc-powerpc64le-linux-gnu g++-powerpc64le-linux-gnu linux-libc-dev-ppc64el-cross \
    # # other
    # gcc-i686-linux-gnu g++-i686-linux-gnu linux-libc-dev-i386-cross \
    # gcc-riscv64-linux-gnu g++-riscv64-linux-gnu linux-libc-dev-riscv64-cross \
    # gcc-s390x-linux-gnu g++-s390x-linux-gnu linux-libc-dev-s390x-cross \
    # tools
    git make upx curl wget;

ENV TRIPLE_armv5="arm-linux-gnueabi"
ENV CFLAGS_armv5="-I/usr/include/${TRIPLE_armv5} -I/usr/${TRIPLE_armv5}/include"
ENV LDFLAGS_armv5="-L/lib/${TRIPLE_armv5} -L/usr/lib/${TRIPLE_armv5}"

ENV TRIPLE_armv6="arm-linux-gnueabi"
ENV CFLAGS_armv6="-I/usr/include/${TRIPLE_armv6} -I/usr/${TRIPLE_armv6}/include"
ENV LDFLAGS_armv6="-L/lib/${TRIPLE_armv6} -L/usr/lib/${TRIPLE_armv6}"

ENV TRIPLE_armv7="arm-linux-gnueabihf"
ENV CFLAGS_armv7="-I/usr/include/${TRIPLE_armv7} -I/usr/${TRIPLE_armv7}/include"
ENV LDFLAGS_armv7="-L/lib/${TRIPLE_armv7} -L/usr/lib/${TRIPLE_armv7}"

ENV TRIPLE_arm64="aarch64-linux-gnueabihf"
ENV CFLAGS_arm64="-I/usr/include/${TRIPLE_arm64} -I/usr/${TRIPLE_arm64}/include"
ENV LDFLAGS_arm64="-L/lib/${TRIPLE_arm64} -L/usr/lib/${TRIPLE_arm64}"

ENV TRIPLE_mpis="mips-linux-gnu"
ENV CFLAGS_mips="-I/usr/include/${TRIPLE_mips} -I/usr/${TRIPLE_mips}/include"
ENV LDFLAGS_mips="-L/lib/${TRIPLE_mips} -L/usr/lib/${TRIPLE_mips}"

ENV TRIPLE_mpisle="mipsel-linux-gnu"
ENV CFLAGS_mipsle="-I/usr/include/${TRIPLE_mipsle} -I/usr/${TRIPLE_mipsle}/include"
ENV LDFLAGS_mipsle="-L/lib/${TRIPLE_mipsle} -L/usr/lib/${TRIPLE_mipsle}"

ENV TRIPLE_mpis64="mips64-linux-gnu"
ENV CFLAGS_mips64="-I/usr/include/${TRIPLE_mips64} -I/usr/${TRIPLE_mips64}/include"
ENV LDFLAGS_mips64="-L/lib/${TRIPLE_mips64} -L/usr/lib/${TRIPLE_mips64}"

ENV TRIPLE_mpis64le="mips64el-linux-gnu"
ENV CFLAGS_mips64le="-I/usr/include/${TRIPLE_mips64le} -I/usr/${TRIPLE_mips64le}/include"
ENV LDFLAGS_mips64le="-L/lib/${TRIPLE_mips64le} -L/usr/lib/${TRIPLE_mips64le}"

ENV TRIPLE_ppc64="powerpc64-linux-gnu"
ENV CFLAGS_ppc64="-I/usr/include/${TRIPLE_ppc64} -I/usr/${TRIPLE_ppc64}/include"
ENV LDFLAGS_ppc64="-L/lib/${TRIPLE_ppc64} -L/usr/lib/${TRIPLE_ppc64}"

ENV TRIPLE_ppc64le="powerpc64le-linux-gnu"
ENV CFLAGS_ppc64le="-I/usr/include/${TRIPLE_ppc64le} -I/usr/${TRIPLE_ppc64le}/include"
ENV LDFLAGS_ppc64le="-L/lib/${TRIPLE_ppc64le} -L/usr/lib/${TRIPLE_ppc64le}"

ENV TRIPLE_riscv64="riscv64-linux-gnu"
ENV CFLAGS_riscv64="-I/usr/include/${TRIPLE_riscv64} -I/usr/${TRIPLE_riscv64}/include"
ENV LDFLAGS_riscv64="-L/lib/${TRIPLE_riscv64} -L/usr/lib/${TRIPLE_riscv64}"

ENV TRIPLE_s390x="s390x-linux-gnu"
ENV CFLAGS_s390x="-I/usr/include/${TRIPLE_s390x} -I/usr/${TRIPLE_s390x}/include"
ENV LDFLAGS_s390x="-L/lib/${TRIPLE_s390x} -L/usr/lib/${TRIPLE_s390x}"
