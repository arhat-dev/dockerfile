#!/bin/sh

set -ex

# MIRROR_SITE="${MIRROR_SITE}"

host_arch="$1"
cross_arch="$2"
cross_triple_name="$3"

case "${cross_arch}" in
ppc64 | riscv64)
  wget -qO- https://www.ports.debian.org/archive_2021.key | apt-key add -

  cat <<EOF >>/etc/apt/sources.list
deb [arch=${cross_arch}] http://ftp.ports.debian.org/debian-ports unstable main
deb [arch=${cross_arch}] http://ftp.ports.debian.org/debian-ports unreleased main
deb [arch=${cross_arch}] http://ftp.ports.debian.org/debian-ports experimental main
EOF
  ;;
*)
  dpkg --add-architecture "${cross_arch}"
  sed -i "s/^deb\\b/& [arch=${host_arch},${cross_arch}]/g" /etc/apt/sources.list
esac

cat /etc/apt/sources.list

if [ -n "${MIRROR_SITE}" ]; then
  sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list
  sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y

apt-get update
apt-get install -y --no-install-recommends \
  git make curl build-essential wget ca-certificates \
  "gcc-${cross_triple_name}" \
  "g++-${cross_triple_name}" \
  "linux-libc-dev-${cross_arch}-cross"

rm -rf /var/lib/apt/lists/*
