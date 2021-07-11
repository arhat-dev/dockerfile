ARG DOCKERHUB_ARCH
ARG ROOTFS_VERSION
ARG MATRIX_ROOTFS

FROM docker.io/${DOCKERHUB_ARCH}/${MATRIX_ROOTFS}:${ROOTFS_VERSION}

ARG VERSION
ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY app/nix/setup.sh /setup.sh
RUN sh /setup.sh && rm -f /setup.sh

ENV ENV /etc/profile
ENV USER root
ENV PATH /nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin
ENV GIT_SSL_CAINFO /etc/ssl/certs/ca-certificates.crt
ENV NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
ENV NIX_PATH /nix/var/nix/profiles/per-user/root/channels
