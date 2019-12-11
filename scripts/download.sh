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
  local arch="$1"
  local version="v4.1.0-1"

  case "${arch}" in
    amd64)
      arch=""
    ;;
    armv*)
      arch=arm
    ;;
    arm64)
      arch=aarch64
    ;;
  esac

  if [ -n "${arch}" ]; then
    wget -O /qemu-${arch}-static \
      https://github.com/multiarch/qemu-user-static/releases/download/${version}/qemu-${arch}-static
    chmod +x /qemu-${arch}-static
  else
    touch /qemu-none
  fi
}

v2ray() {
  local arch="$1"
  local v2ray_arch="$arch"
  local version="v4.20.0"

  case "${v2ray_arch}" in
    amd64)
      v2ray_arch=64
    ;;
    armv*)
      v2ray_arch=arm
    ;;
  esac

  wget -O /v2ray.zip \
    https://github.com/v2ray/v2ray-core/releases/download/${version}/v2ray-linux-${v2ray_arch}.zip 
  mkdir -p /v2ray
  unzip /v2ray.zip -d /v2ray

  if [ "${arch}" = armv7 ]; then
    rm -f /v2ray/v2ray /v2ray/v2ctl
    mv /v2ray/v2ray_armv7 /v2ray/v2ray
    mv /v2ray/v2ctl_armv7 /v2ray/v2ctl
  fi
}

frp() {
  local arch="$1"
  local frp_arch="${arch}"
  local version="0.29.0"

  case "${arch}" in
    armv*)
      frp_arch=arm
      ;;
  esac

  local file_name=frp_${version}_linux_${frp_arch}

  wget -O /frp.tar.gz \
    https://github.com/fatedier/frp/releases/download/v${version}/${file_name}.tar.gz
  
  tar -xf /frp.tar.gz
  mv /${file_name} /frp
}

github_runner() {
  local arch="$1"
  local runner_arch="${arch}"
  local version="2.161.0"

  case "${arch}" in
    amd64)
      runner_arch="x64"
      ;;
    armv7)
      runner_arch="arm"
      ;;
  esac

  wget -O /github-runner.tar.gz \
    https://githubassets.azureedge.net/runners/${version}/actions-runner-linux-${runner_arch}-${version}.tar.gz

  mkdir -p /github-runner
  tar -xf /github-runner.tar.gz -C /github-runner
}

kubectl() {
  local arch="$1"
  local kubectl_arch="${arch}"
  local version="v1.16.3"

  case "${arch}" in
    armv7)
      kubectl_arch="arm"
  esac

  wget -O "/kubectl-${arch}" \
    "https://storage.googleapis.com/kubernetes-release/release/${version}/bin/linux/${kubectl_arch}/kubectl"

  chmod +x "/kubectl-${arch}"
  mkdir -p kubectl
  mv "/kubectl-${arch}" /kubectl/kubectl
}

helm() {
  local arch="$1"
  local helm_arch="${arch}"
  local version="v3.0.1"

  case "${arch}" in
    armv7)
      helm_arch="arm"
  esac

  wget -O /helm.tar.gz \
    "https://get.helm.sh/helm-${version}-linux-${helm_arch}.tar.gz"
  
  mkdir -p /helm
  tar -xf /helm.tar.gz -C /helm
  mv "/helm/linux-${helm_arch}/helm" /helm/helm
}

"$@"
