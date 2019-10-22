FROM golang:buster

ARG MIRROR_SITE

# add multiarchs
RUN set -e;\
    dpkg --add-architecture armhf ;\
    dpkg --add-architecture armel ;\
    dpkg --add-architecture arm64 ;

# use https to fetch packages
# in consideration of https://security-tracker.debian.org/tracker/CVE-2019-3462
RUN set -e ;\
    if [ -n "${MIRROR_SITE}" ]; then \
      sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list ;\
      sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list ;\
    fi ;\
    sed -i 's/^deb\b/& [arch=amd64,arm64,armhf,armel]/g' /etc/apt/sources.list ;

# install dependencies
RUN set -e ;\
    # apt-get update ;\
    # apt-get install -y apt-transport-https ;\
    # sed -i 's/http:/https:/g' /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;

RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
    # cross compilers
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi libc-dev-armel-cross \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libc-dev-armhf-cross \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libc-dev-arm64-cross \
    # tools
    git make upx curl wget;
