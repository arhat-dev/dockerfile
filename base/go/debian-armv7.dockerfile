# use native build to make sure qemu executable
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu armv7

FROM arm32v7/golang:stretch

# add qemu for cross build
COPY --from=downloader /qemu* /usr/bin/

ARG MIRROR_SITE=mirrors.ocf.berkeley.edu

# use https to fetch packages
# in consideration of https://security-tracker.debian.org/tracker/CVE-2019-3462
RUN set -e ;\
    if [ ! -z "${MIRROR_SITE}" ]; then \
      sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list ;\
      sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list ;\
    fi ;

# install dependencies
RUN set -e ;\
    apt-get update ;\
    apt-get install -y apt-transport-https ;\
    sed -i 's/http:/https:/g' /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;\
    apt-get install -y --no-install-recommends \
    git make upx build-essential apparmor autoconf automake \
    bison curl e2fslibs-dev gawk gettext go-md2man iptables \
    pkg-config libaio-dev libcap-dev libfuse-dev libnet-dev \
    libnl-3-dev libostree-dev libprotobuf-dev libprotobuf-c-dev \
    libseccomp2 libseccomp-dev libtool libudev-dev protobuf-c-compiler \
    protobuf-compiler libglib2.0-dev libapparmor-dev btrfs-tools \
    libdevmapper1.02.1 libdevmapper-dev libgpgme11-dev liblzma-dev \
    netcat socat lsof xz-utils unzip python3-yaml ;
