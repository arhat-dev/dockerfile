ARG DOCKERHUB_ARCH
ARG ROOTFS_VERSION
ARG MATRIX_ROOTFS

FROM docker.io/${DOCKERHUB_ARCH}/${MATRIX_ROOTFS}:${ROOTFS_VERSION} AS builder

ARG VERSION
ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY nix/setup.sh /setup.sh
RUN sh /setup.sh && rm -f /setup.sh

# setup.sh will create user `nixuser` (uid: 20000)

ENV USER="nixuser" \
    ENV="/etc/profile" \
    NIX_PATH="/nix/var/nix/profiles/per-user/${USER}/channels" \
    GIT_SSL_CAINFO="/etc/ssl/certs/ca-certificates.crt" \
    NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

ENV PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

USER 20000

RUN set -eux ;\
    nix-channel --add \
      https://nixos.org/channels/nixpkgs-unstable unstable ;\
    nix-channel --add \
      https://channels.nixos.org/nixos-21.05-small stable ;\
    nix-channel --update ;\
    rm /nix/var/nix/gcroots/auto/* || true ;\
    nix-store --gc ;\
    nix optimise-store ;\
    nix-store --verify --check-contents

FROM scratch

COPY --from=builder / /

ENV PATH="/nix/var/nix/profiles/default/sbin:${PATH}" \
    PATH="/nix/var/nix/profiles/default/bin:${PATH}" \
# /nixuser/bin doesn't really exits now, and should be used by final app image
    PATH="/nixuser/bin:/nixuser/.nix-profile/bin:${PATH}"

ENV USER="nixuser" \
    ENV="/etc/profile" \
    NIX_PATH="/nix/var/nix/profiles/per-user/${USER}/channels" \
    GIT_SSL_CAINFO="/etc/ssl/certs/ca-certificates.crt" \
    NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

USER 20000

WORKDIR /nixuser
