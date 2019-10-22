#!/bin/sh

IMAGE_REPOS="docker.pkg.github.com/arhat-dev/dockerfile docker.io/arhatdev"

get_tag_args() {
  local name="$1"
  local result=""
  for repo in ${IMAGE_REPOS}; do
    result="-t ${repo}/${name} ${result}"
  done
  printf "%s" "${result}"
}
