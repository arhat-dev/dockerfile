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

QEMU_VERSION="v5.2.0-2"           # https://github.com/multiarch/qemu-user-static/releases
KUBECTL_VERSION="v1.21.2"         # https://github.com/kubernetes/kubernetes/releases
HELM_VERSION="v3.6.1"             # https://github.com/helm/helm/releases

qemu() {
  arch="$1"
  version="${QEMU_VERSION}"

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
  ppc64le)
    arch=ppc64le
    ;;
  s390x)
    arch=s390x
    ;;
  x86)
    arch=i386
    ;;
  mips64le)
    arch=mips64el
    ;;
  esac

  if [ -n "${arch}" ]; then
    wget -O /qemu-${arch}-static \
      "https://github.com/multiarch/qemu-user-static/releases/download/${version}/qemu-${arch}-static"
    chmod +x /qemu-${arch}-static
  else
    touch /qemu-none
  fi
}

kubectl() {
  arch="$1"
  kubectl_arch="${arch}"
  version="${KUBECTL_VERSION}"

  case "${arch}" in
  armv7)
    kubectl_arch="arm"
    ;;
  esac

  wget -O "/kubectl-${arch}" \
    "https://storage.googleapis.com/kubernetes-release/release/${version}/bin/linux/${kubectl_arch}/kubectl"

  chmod +x "/kubectl-${arch}"
  mkdir -p kubectl
  mv "/kubectl-${arch}" /kubectl/kubectl
}

helm() {
  arch="$1"
  helm_arch="${arch}"
  version="${HELM_VERSION}"

  case "${arch}" in
  armv7)
    helm_arch="arm"
    ;;
  esac

  wget -O /helm.tar.gz \
    "https://get.helm.sh/helm-${version}-linux-${helm_arch}.tar.gz"

  mkdir -p /helm
  tar -xf /helm.tar.gz -C /helm
  mv "/helm/linux-${helm_arch}/helm" /helm/helm
}

"$@"
