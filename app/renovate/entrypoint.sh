#!/bin/sh

nix_bin_path="/app/.nix-profile/bin"
nix_bin_path="${nix_bin_path}:/nix/var/nix/profiles/default/bin"
nix_bin_path="${nix_bin_path}:/nix/var/nix/profiles/default/sbin"

export PATH="${nix_bin_path}:${PATH}"

# shellcheck disable=2068
exec $@
