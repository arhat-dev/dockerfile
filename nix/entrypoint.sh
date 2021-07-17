#!/bin/sh

if ! command -v nix-env >/dev/null; then
  export PATH="/nix/var/nix/profiles/default/sbin:/nix/var/nix/profiles/default/bin:${PATH}"
fi
