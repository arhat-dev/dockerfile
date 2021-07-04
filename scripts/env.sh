#!/bin/sh

IMAGE_REPOS="ghcr.io/arhat-dev"

get_tag_args() {
  name="$1"
  result=""
  for repo in ${IMAGE_REPOS}; do
    result="-t ${repo}/${name} ${result}"
  done
  printf "%s" "${result}"
}

# arch list

# amd64
# x86
# armv{5,6,7}
# arm64
# ppc64{,le}
# mips{,hf}
# mipsle{,hf}
# mips64{,hf}
# mips64le{,hf}
# riscv64
# s390x

get_docker_arch() {
  arch="$1"

  case "${arch}" in
  x86)
    printf "i386"
    ;;
  armv*)
    # arm32v{5,6,7}
    printf "arm32v%d" "${arch#armv}"
    ;;
  arm64)
    printf "arm64v8"
    ;;
  amd64 | mips64le | ppc64le | s390x)
    printf "%s" "${arch}"
    ;;
  *)
    printf "unmapped arch %s for docker arch" "${arch}" >&2
    exit 1
    ;;
  esac
}

get_docker_manifest_arch() {
  arch="$1"

  case "${arch}" in
  x86)
    printf "386"
    ;;
  armv*)
    # arm32v{5,6,7}
    printf "arm"
    ;;
  arm64)
    printf "arm64"
    ;;
  amd64 | mips64le | ppc64le | s390x)
    printf "%s" "${arch}"
    ;;
  esac
}

get_docker_manifest_arch_variant() {
  arch="$1"

  case "${arch}" in
  armv*)
    # arm32v{5,6,7}
    printf "%d" "${arch#armv}"
    ;;
  *)
    printf ""
    ;;
  esac
}
