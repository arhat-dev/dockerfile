FROM rust:buster

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
    echo "deb [arch=ppc64,riscv64] http://ftp.ports.debian.org/debian-ports main" >> /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;

RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
    # cross compilers
    build-essential \
    gcc-arm-linux-gnueabi \
    gcc-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    # gcc-mips-linux-gnu \
    # gcc-mipsel-linux-gnu \
    # gcc-mips64-linux-gnuabi64 \
    # gcc-mips64el-linux-gnuabi64 \
    # gcc-powerpc-linux-gnu \
    # gcc-powerpc64-linux-gnu \
    # gcc-powerpc64le-linux-gnu \
    # gcc-i686-linux-gnu \
    # gcc-riscv64-linux-gnu \
    # gcc-s390x-linux-gnu \
    # tools
    git make upx curl wget musl-tools ;

# add cross compile targets
RUN rustup target add arm-unknown-linux-gnueabi ;\
      rustup target add armv7-unknown-linux-gnueabihf ;\
      rustup target add aarch64-unknown-linux-gnu ;\
      rustup target add x86_64-unknown-linux-gnu ;\
    #   rustup target add mips-unknown-linux-gnu ;\
    #   rustup target add mipsel-unknown-linux-gnu ;\
    #   rustup target add mips64-unknown-linux-gnuabi64 ;\
    #   rustup target add mips64el-unknown-linux-gnuabi64 ;\
    #   rustup target add powerpc-unknown-linux-gnu ;\
    #   rustup target add powerpc64-unknown-linux-gnu ;\
    #   rustup target add powerpc64le-unknown-linux-gnu ;\
    #   rustup target add s390x-unknown-linux-gnu ;\
      # musl libc
      rustup target add arm-unknown-linux-musleabi ;\
      rustup target add armv7-unknown-linux-musleabihf ;\
      rustup target add aarch64-unknown-linux-musl ;\
      rustup target add x86_64-unknown-linux-musl ;
    #   rustup target add mips-unknown-linux-musl ;\
    #   rustup target add mipsel-unknown-linux-musl ;

COPY scripts/rust/cargo-config/debian-amd64.toml /root/.cargo/config
