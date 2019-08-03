FROM golang:stretch

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
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi libc-dev-armel-cross \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libc-dev-armhf-cross \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libc-dev-arm64-cross \
    # tools
    git make upx build-essential apparmor autoconf automake \
    bison curl e2fslibs-dev gawk gettext go-md2man iptables \
    btrfs-tools pkg-config protobuf-compiler protobuf-c-compiler \
    netcat socat lsof xz-utils unzip python3-yaml \
    # source files
    libdevmapper-dev libgpgme11-dev \
    liblzma-dev libglib2.0-dev libapparmor-dev \
    libaio-dev libcap-dev libfuse-dev libnet-dev \
    libnl-3-dev libostree-dev libprotobuf-dev libprotobuf-c-dev \
    libseccomp-dev libudev-dev \
    # libraries
    libseccomp2 libdevmapper1.02.1 libtool \
    libseccomp2:armel libdevmapper1.02.1:armel libtool:armel \
    libseccomp2:armhf libdevmapper1.02.1:armhf libtool:armhf \
    libseccomp2:arm64 libdevmapper1.02.1:arm64 libtool:arm64
