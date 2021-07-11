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

replace_root_user() {
  user="$1"
  group="$2"
  home="$3"

  nix_profile_dir="/nix/var/nix/profiles/per-user/${user}"

  rm -rf \
    /root/.cache /root/.nix* \
    /nix/var/nix/profiles/per-user/root

  mkdir -p "${nix_profile_dir}"
  chown -R "${user}:${group}" "${nix_profile_dir}"

  ln -s "${nix_profile_dir}/profile" "$home/.nix-profile"
  chown -h "${user}:${group}" "$home/.nix-profile"

  (
    echo ". /etc/profile.d/nix.sh"
    echo "export PATH=\"/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:\${PATH}\""
  ) >>"$home/.profile"

  chown -R "${user}:${group}" /nix
}

install_nix() {
  wget "${download_url}"

  mkdir -p /build
  tar xf "${filename}.tar.xz" -C /build
  rm -rf nix-*.tar.xz

  mkdir -m 0755 /etc/nix

  (
    echo 'sandbox = false'
    echo 'filter-syscalls = false'
  ) >/etc/nix/nix.conf

  mkdir -m 0755 /nix && USER=root sh "/build/${filename}/install"
  rm -rf "/build"

  ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/

  export PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"
  nix-collect-garbage -d
  # nix optimise-store
  nix-store --verify --check-contents

  replace_root_user nixuser nixgroup /app
}

setup_alpine() {
  # Enable HTTPS support in wget and set nsswitch.conf to make resolution work within containers
  apk add --no-cache --update openssl
  echo hosts: files dns >/etc/nsswitch.conf

  # user for nix
  addgroup -g 30000 -S nixbld

  for i in $(seq 1 30); do
    adduser \
      -S -D -h /var/empty -g "Nix build user $i" \
      -u $((30000 + i)) -G nixbld "nixbld$i"
  done

  # user for container app
  addgroup -g 20000 -S nixgroup
  adduser \
    -S -D -h /app -g "Container App" \
    -u 20000 -G nixgroup \
    nixuser
}

setup_debian() {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y openssl wget xz-utils
  echo hosts: files dns >/etc/nsswitch.conf

  addgroup --system --gid 30000 nixbld

  for i in $(seq 1 30); do
    adduser --system \
      --disabled-password \
      --home /var/empty \
      --gecos "Nix build user $i" \
      --uid $((30000 + i)) "nixbld$i"
    adduser "nixbld$i" nixbld
  done

  # user for container app
  addgroup --gid 20000 nixgroup
  adduser \
    --disabled-password \
    --home /app \
    --gecos "Container App" \
    --uid 20000 \
    --gid 20000 \
    nixuser
  adduser nixuser nixgroup
}

case "${MATRIX_ROOTFS}" in
debian)
  setup_debian
  install_nix
  rm -rf /var/lib/apt/lists/*
  ;;
alpine)
  setup_alpine
  install_nix
  rm -rf /var/cache/apk/*
  ;;
*)
  echo "Unsupported rootfs ${MATRIX_ROOTFS}"
  exit 1
  ;;
esac
