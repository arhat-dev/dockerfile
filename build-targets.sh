#!/bin/sh

set -e

# use gnu grep on macOS, fallback to grep on linux
GREP=$(which ggrep || which grep)

ALL_TARGETS=$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u)

domake() {
    local RECIPES=$1
    echo "-----------------Targets-----------------"
    echo "$RECIPES"
    echo "---------------Build-Start---------------"
    for r in $RECIPES; do
        echo "make $r"
        make "$r"
    done
}

base() {
    domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^base-')"
}

builder() {
    domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^builder-')"
}

container() {
    domake "$(echo "$ALL_TARGETS" | $GREP -P -e '^(?!(push|base|builder|Makefile))')"
}

push() {
    domake "$(echo "$ALL_TARGETS" | $GREP -E -e '^push-')"
}

"$@"
