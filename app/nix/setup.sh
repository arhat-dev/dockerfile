#!/bin/sh

# Reference:
# https://github.com/NixOS/docker/blob/master/Dockerfile

set -ex

nix_arch=""

case "${MATRIX_ARCH}" in
  amd64)
    nix_arch="x86_64"
    ;;
  arm64)
    nix_arch="aarch64"
    ;;
  x86)
    nix_arch="i686"
    ;;
  *)
    echo "Unsupported arch ${MATRIX_ARCH}"
    exit 1
    ;;
esac

base_url="https://releases.nixos.org/nix/nix-${VERSION}"
filename="nix-${VERSION}-${nix_arch}-linux"
download_url="${base_url}/${filename}.tar.xz"

install_nix() {
  wget "${download_url}"

  mkdir -p /build
  tar xf "${filename}.tar.xz" -C /build

  mkdir -m 0755 /etc/nix

  (
    echo 'sandbox = false'
    echo 'filter-syscalls = false'
  ) > /etc/nix/nix.conf

  mkdir -m 0755 /nix && USER=root sh "/build/${filename}/install"

  ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/

  rm -r "/build"

  /nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-old
  /nix/var/nix/profiles/default/bin/nix-store --optimise
  /nix/var/nix/profiles/default/bin/nix-store --verify --check-contents
}

setup_alpine() {
  # Enable HTTPS support in wget and set nsswitch.conf to make resolution work within containers
  apk add --no-cache --update openssl
  echo hosts: files dns > /etc/nsswitch.conf

  addgroup -g 30000 -S nixbld

  for i in $(seq 1 30); do
    adduser \
      -S -D -h /var/empty -g "Nix build user $i" \
      -u $((30000 + i)) -G nixbld "nixbld$i"
  done
}

setup_debian() {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y openssl wget xz-utils
  echo hosts: files dns > /etc/nsswitch.conf

  addgroup --system --gid 30000 nixbld

  for i in $(seq 1 30); do
    adduser --system \
      --disabled-password \
      --home /var/empty \
      --gecos "Nix build user $i" \
      --uid $((30000 + i)) "nixbld$i"
    adduser "nixbld$i" nixbld
  done
}

case "${MATRIX_ROOTFS}" in
  debian)
    setup_debian
    install_nix
    rm -rf /var/cache/apk/*
    ;;
  alpine)
    setup_alpine
    install_nix
    rm -rf /var/lib/apt/lists/*
    ;;
  *)
    echo "Unsupported rootfs ${MATRIX_ROOTFS}"
    exit 1
    ;;
esac
