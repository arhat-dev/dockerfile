#!/bin/bash

# ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitlab-shell/scripts/authorized_keys

if [[ "$1" == "git" ]]; then
  /srv/gitlab-shell/bin/gitlab-shell-authorized-keys-check git "$1" "$2"
fi
