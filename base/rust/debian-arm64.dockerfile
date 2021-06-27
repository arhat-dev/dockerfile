FROM docker.io/multiarch/qemu-user-static:x86_64-aarch64-5.2.0-2 as qemu
FROM docker.io/arm64v8/rust:buster

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=qemu /usr/bin/qemu* /usr/bin/

ARG MIRROR_SITE

# use https to fetch packages
# in consideration of https://security-tracker.debian.org/tracker/CVE-2019-3462
RUN set -e ;\
    if [ -n "${MIRROR_SITE}" ]; then \
      sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list ;\
      sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list ;\
    fi ;

# install dependencies
RUN set -e ;\
    # apt-get update ;\
    # apt-get install -y apt-transport-https ;\
    # sed -i 's/http:/https:/g' /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;\
    apt-get install -y --no-install-recommends \
      git make curl build-essential wget musl-tools ;

# add musl target
RUN rustup target add aarch64-unknown-linux-musl

COPY scripts/rust/cargo-config/debian-arm64.toml /root/.cargo/config

ENV _NATIVE_LIBC=gnu
ENV _NATIVE_ARCH=arm64
