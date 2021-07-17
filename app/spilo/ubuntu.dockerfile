ARG MATRIX_ARCH
ARG DOCKERHUB_ARCH

FROM ghcr.io/arhat-dev/wal-g:1.0-${MATRIX_ARCH} AS walg_img
FROM ghcr.io/arhat-dev/etcd:3.5.0-${MATRIX_ARCH} AS etcd_img

FROM docker.io/${DOCKERHUB_ARCH}/ubuntu:20.04 as base

# TODO: very strange, spilo build will error if this directory is not removed
#       they are using `rm -rf` as well
RUN rm -rf /usr/share/man

FROM scratch

COPY --from=base / /

COPY --from=walg_img /wal-g.pg /usr/loca/bin/wal-g
COPY --from=etcd_img /etcdctl /etcd /bin/
