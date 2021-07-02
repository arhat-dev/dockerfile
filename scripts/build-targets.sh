#!/bin/sh

set -e

. scripts/env.sh

# use gnu grep on macOS, fallback to grep on linux
GREP=$(command -v ggrep || command -v grep)

ALL_TARGETS=$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u)

domake() {
  RECIPES="$1"
  echo "-----------------Targets-----------------"
  echo "${RECIPES}"
  echo "---------------Build-Start---------------"
  for r in ${RECIPES}; do
    echo "make $r"
    make "$r"
  done
}

base() {
  domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^base' | $GREP -E -e "$1")"
}

builder() {
  domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^builder' | $GREP -E -e "$1")"
}

container() {
  domake "$(echo "$ALL_TARGETS" | $GREP -P -e '^(?!(push|base|builder|images|Makefile|app))' | $GREP -E -e "$1")"
}

"$@"
