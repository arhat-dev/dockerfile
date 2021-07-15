# `nix` Image

For Applications With Many Dependencies

## What's inside

User: `nixuser` (uid: `20000`)
Group: `nixgroup` (gid: `20000`)

Channels:

- `stable`: [https://channels.nixos.org/nixos-21.05-small](https://channels.nixos.org/nixos-21.05-small)
- `unstable`: [https://nixos.org/channels/nixpkgs-unstable](https://nixos.org/channels/nixpkgs-unstable)

## Usage

- Install dependencies using `nix -iA <your-required-packages>` as `nixuser`
- Save built application executables to `/nixuser/bin`
