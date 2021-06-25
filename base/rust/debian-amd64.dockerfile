FROM rust:buster

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
    if [ -n "${MIRROR_SITE}" ]; then \
      sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list ;\
      sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list ;\
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
    # cross compilers
    build-essential \
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
    git make curl wget musl-tools xz-utils ;

RUN set -e ;\
    # add arm 32bit cross compiler
    curl -o arm-none-linux-gnueabihf.tar.xz -sSfL https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz ;\
    tar xf arm-none-linux-gnueabihf.tar.xz ;\
    mv gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf /opt/arm-none-linux-gnueabihf ;\
    rm -rf arm-none-linux-gnueabihf.tar.xz ;\
    # add arm aarch64 cross compiler
    curl -o aarch64-none-linux-gnu.tar.xz -sSfL https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz ;\
    tar xf aarch64-none-linux-gnu.tar.xz ;\
    mv gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu /opt/aarch64-none-linux-gnu ;\
    rm -rf aarch64-none-linux-gnu.tar.xz

ENV PATH="${PATH}:/opt/arm-none-linux-gnueabihf/bin:/opt/aarch64-none-linux-gnu"

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
