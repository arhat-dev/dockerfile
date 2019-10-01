FROM rust:stretch

ARG MIRROR_SITE=mirrors.ocf.berkeley.edu

# add multiarchs
RUN set -e;\
    dpkg --add-architecture armhf ;\
    dpkg --add-architecture armel ;\
    dpkg --add-architecture arm64 ;

# use https to fetch packages
# in consideration of https://security-tracker.debian.org/tracker/CVE-2019-3462
RUN set -e ;\
    if [ ! -z "${MIRROR_SITE}" ]; then \
      sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list ;\
      sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list ;\
    fi ;\
    sed -i 's/^deb\b/& [arch=amd64,arm64,armhf,armel]/g' /etc/apt/sources.list ;

# install dependencies
RUN set -e ;\
    apt-get update ;\
    apt-get install -y apt-transport-https ;\
    sed -i 's/http:/https:/g' /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;

RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
    # cross compilers
    build-essential \
    gcc-arm-linux-gnueabi \
    gcc-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    # tools
    git make upx curl wget musl-tools ;

# add cross compile targets
RUN rustup target add arm-unknown-linux-gnueabi ;\
      rustup target add armv7-unknown-linux-gnueabihf ;\
      rustup target add aarch64-unknown-linux-gnu ;\
      rustup target add x86_64-unknown-linux-gnu ;\
      # musl libc
      rustup target add arm-unknown-linux-musleabi ;\
      rustup target add armv7-unknown-linux-musleabihf ;\
      rustup target add aarch64-unknown-linux-musl ;\
      rustup target add x86_64-unknown-linux-musl

COPY scripts/rust/cargo-config/debian-amd64.toml /root/.cargo/config
