ARG DOCKERHUB_ARCH
ARG ROOTFS_VERSION
ARG MATRIX_ROOTFS

FROM docker.io/${DOCKERHUB_ARCH}/${MATRIX_ROOTFS}:${ROOTFS_VERSION}

ARG VERSION
ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY nix/setup.sh /setup.sh
RUN sh /setup.sh && rm -f /setup.sh

USER nixuser
ENV USER nixuser
ENV ENV /etc/profile
ENV NIX_PATH /nix/var/nix/profiles/per-user/nixuser/channels
ENV GIT_SSL_CAINFO /etc/ssl/certs/ca-certificates.crt
ENV NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt

ENV PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

RUN set -ex ;\
    nix-channel --remove nixpkgs ;\
    nix-channel --add \
      https://nixos.org/channels/nixpkgs-unstable unstable ;\
    nix-channel --add \
      https://channels.nixos.org/nixos-21.05-small stable ;\
    nix-channel --update ;\
    nix-store --delete ;\
    nix optimise-store ;\
    nix-store --verify --check-contents

WORKDIR /nixuser
