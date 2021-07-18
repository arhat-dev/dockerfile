ARG DOCKERHUB_ARCH
ARG MATRIX_ROOTFS
ARG ROOTFS_VERSION

FROM docker.io/${DOCKERHUB_ARCH}/${MATRIX_ROOTFS}:${ROOTFS_VERSION} AS builder

ARG VERSION
ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

COPY nix/setup.sh /setup.sh
RUN sh /setup.sh && rm -f /setup.sh

# setup.sh will create user `nixuser` (uid: 20000)

ENV USER="nixuser" \
    ENV="/etc/profile" \
    NIX_PATH="/nix/var/nix/profiles/per-user/nixuser/channels" \
    GIT_SSL_CAINFO="/etc/ssl/certs/ca-certificates.crt" \
    NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

COPY nix/entrypoint.sh /usr/local/bin/nix-entrypoint
RUN chmod a+x /usr/local/bin/nix-entrypoint

USER nixuser

RUN set -eux ;\
    nix-entrypoint nix-channel --add \
      https://nixos.org/channels/nixpkgs-unstable unstable ;\
    nix-entrypoint nix-channel --add \
      https://channels.nixos.org/nixos-21.05-small stable ;\
    nix-entrypoint nix-channel --update ;\
    nix-entrypoint nix-env -iA stable.tini ;\
    rm /nix/var/nix/gcroots/auto/* || true ;\
    nix-entrypoint nix-store --gc ;\
    nix-entrypoint nix optimise-store ;\
    nix-entrypoint nix-store --verify --check-contents

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ENV PATH="/nix/var/nix/profiles/default/sbin:${PATH}" \
    PATH="/nix/var/nix/profiles/default/bin:${PATH}" \
    PATH="/nixuser/.nix-profile/bin:${PATH}"

ENV USER="nixuser" \
    ENV="/etc/profile" \
    NIX_PATH="/nix/var/nix/profiles/per-user/nixuser/channels" \
    GIT_SSL_CAINFO="/etc/ssl/certs/ca-certificates.crt" \
    NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

USER 20000

WORKDIR /nixuser

ENTRYPOINT [ "/usr/local/bin/nix-entrypoint" ]
