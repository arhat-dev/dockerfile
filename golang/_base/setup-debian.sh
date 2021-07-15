#!/bin/sh

set -ex

if [ -n "${MIRROR_SITE}" ]; then
  sed -i "s/deb.debian.org/${MIRROR_SITE}/g" /etc/apt/sources.list
  sed -i "s|security.debian.org/debian-security|${MIRROR_SITE}/debian-security|g" /etc/apt/sources.list
fi

# TODO: use https to fetch packages
#       in consideration of https://security-tracker.debian.org/tracker/CVE-2019-3462

# apt update
# apt install -y apt-transport-https
# sed -i 's/http:/https:/g' /etc/apt/sources.list

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends \
  git make curl build-essential wget ca-certificates
