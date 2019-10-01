#!/bin/sh

# Copyright 2019 The arhat.dev Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

qemu() {
  local ARCH=$1
  local VERSION=v4.1.0-1

  case "${ARCH}" in
    amd64)
      ARCH=""
    ;;
    armv*)
      ARCH=arm
    ;;
    arm64)
      ARCH=aarch64
    ;;
  esac

  if [ ! -z "${ARCH}" ]; then
    wget -O /qemu-${ARCH}-static \
      https://github.com/multiarch/qemu-user-static/releases/download/${VERSION}/qemu-${ARCH}-static
    chmod +x /qemu-${ARCH}-static
  else
    touch /qemu-none
  fi
}

v2ray() {
  local ARCH=$1
  local V2RAY_ARCH=$ARCH
  local VERSION=v4.20.0

  case "${V2RAY_ARCH}" in
    amd64)
      V2RAY_ARCH=64
    ;;
    armv*)
      V2RAY_ARCH=arm
    ;;
  esac

  wget -O /v2ray.zip \
    https://github.com/v2ray/v2ray-core/releases/download/${VERSION}/v2ray-linux-${V2RAY_ARCH}.zip 
  mkdir -p /v2ray
  unzip /v2ray.zip -d /v2ray

  if [ ${ARCH} = armv7 ]; then
    rm -f /v2ray/v2ray /v2ray/v2ctl
    mv /v2ray/v2ray_armv7 /v2ray/v2ray
    mv /v2ray/v2ctl_armv7 /v2ray/v2ctl
  fi
}

frp() {
  local ARCH=$1
  local FRP_ARCH=${ARCH}
  local VERSION="0.29.0"

  case "" in
    armv*)
      FRP_ARCH=arm
      ;;
  esac

  local FILE_NAME=frp_${VERSION}_linux_${FRP_ARCH}

  wget -O /frp.tar.gz \
    https://github.com/fatedier/frp/releases/download/v${VERSION}/${FILE_NAME}.tar.gz
  
  tar -xf /frp.tar.gz
  mv /${FILE_NAME} /frp
}

"$@"
