#!/bin/sh

set -ex

ARCH="${ARCH:-${_NATIVE_ARCH}}"
LIBC="${LIBC:-${_NATIVE_LIBC}}"

cross=true
if [ "${ARCH}" = "${_NATIVE_ARCH}" ]; then
  cross=false
fi

PM=$(which apt-get || which apk || which yum || which dnf)
CC=gcc

export USER=$(whoami)

_prepare_for_apt_get() {
  local pm_arch="amd64"

  case "${ARCH}" in
    armv6)
      pm_arch=armel
      ;;
    armv7)
      pm_arch=armhf
      ;;
    arm64)
      pm_arch=arm64
      ;;
    amd64)
      pm_arch=amd64
      ;;
  esac

  if [ "${LIBC}" = "musl" ]; then
    apt-get update
    apt-get install -y "musl-tools:${pm_arch}"
  fi
}

_prepare_for_yum() {
  : TODO
}

_prepare_for_dnf() {
  : TODO
}

_prepare_for_apk() {
  : TODO
}

case "${PM}" in
  *apt-get*)
    _prepare_for_apt_get
    ;;
  *yum*)
    _prepare_for_yum
    ;;
  *dnf*)
    _prepare_for_dnf
    ;;
  *apk*)
    _prepare_for_apk
    ;;
esac

_build() {
  local bin="${1}"

  local toolchain_prefix="x86_64-unknown-linux-"
  local toolchain_suffix=""

  case "${ARCH}" in
    armv6)
      toolchain_prefix=arm-unknown-linux-
      toolchain_suffix=eabi
      ;;
    armv7)
      toolchain_prefix=armv7-unknown-linux-
      toolchain_suffix=eabihf
      ;;
    arm64)
      toolchain_prefix=aarch64-unknown-linux-
      toolchain_suffix=""
      ;;
    amd64)
      toolchain_prefix=x86_64-unknown-linux-
      toolchain_suffix=""
      ;;
  esac

  if [ "${toolchain_suffix}" = "eabihf" ] && [ "${LIBC}" = "android" ] ; then
    toolchain_suffix=eabi
  fi

  local TOOLCHAIN="${toolchain_prefix}${LIBC}${toolchain_suffix}"
  local BIN_DIR="target/${TOOLCHAIN}/release"
  local CARGO_ARGS="--release --target ${TOOLCHAIN} --bin ${bin}"

  cargo build ${CARGO_ARGS}

  mkdir -p /build

  mv "${BIN_DIR}/${BIN}" /build/${BIN}
}

_build $@
