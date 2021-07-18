ARG MATRIX_ARCH
ARG DOCKERHUB_ARCH

FROM ghcr.io/arhat-dev/wal-g:1.0-${MATRIX_ARCH} AS walg_img
FROM ghcr.io/arhat-dev/etcd:3.5-${MATRIX_ARCH} AS etcd_img

# TODO: build process on ubuntu 20.04 requires qemu with semtimedop support
#       not released yet
FROM docker.io/${DOCKERHUB_ARCH}/ubuntu:18.04 as base

ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux ;\
# TODO: very strange, spilo build will error if this directory is not removed
#       they are using `rm -rf` as well
    rm -rf /usr/share/man ;\
# workaround to get rid of intermittent error
    ln -s -f /bin/true /usr/bin/chfn

FROM scratch

COPY --from=base / /

COPY --from=walg_img /wal-g.pg /usr/loca/bin/wal-g
COPY --from=etcd_img /etcdctl /etcd /bin/
