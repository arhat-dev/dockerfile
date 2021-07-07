#!/bin/sh

# tag_name may include `br-` prefix
# and will cause panic
#
# see https://github.com/arhat-dev/dockerfile/issues/13

src_path="${1}"

tag_name="$(git -C "${src_path}" describe --tags)"

printf "%s" "${tag_name#br-*}"
