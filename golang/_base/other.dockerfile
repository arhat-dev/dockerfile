ARG QEMU_ARCH
ARG QEMU_VERSION

ARG DOCKERHUB_ARCH
ARG GO_VERSION
ARG ROOTFS_WITH_VERSION

FROM docker.io/multiarch/qemu-user-static:x86_64-${QEMU_ARCH}-${QEMU_VERSION} as qemu

FROM docker.io/${DOCKERHUB_ARCH}/golang:${GO_VERSION}-${ROOTFS_WITH_VERSION}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=qemu /usr/bin/qemu* /usr/bin/

ARG MATRIX_ROOTFS
COPY golang/_base/setup-${MATRIX_ROOTFS}.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh
