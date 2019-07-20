# use native build to make sure qemu executable
FROM alpine:latest as downloader

ARG QEMU_VERSION

RUN wget --quiet -O /qemu-arm-static \
    https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_VERSION}/qemu-arm-static ;\
    chmod +x /qemu-arm-static

FROM arm32v7/golang:stretch

# add qemu for cross build
COPY --from=downloader /qemu-arm-static  \
    /usr/bin/qemu-arm-static

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
    apt-get install -y git make upx build-essential ;
