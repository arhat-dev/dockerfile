#!/bin/sh

IMAGE_REPOS="ghcr.io/arhat-dev docker.io/arhatdev"

get_tag_args() {
  name="$1"
  result=""
  for repo in ${IMAGE_REPOS}; do
    result="-t ${repo}/${name} ${result}"
  done
  printf "%s" "${result}"
}
