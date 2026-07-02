# VG001 - Netcup VPS 1000 ARM G11

[VPS Page - Netcup Website](https://www.netcup.com/en/server/arm-server)

## First Time Setup

- Boot from NixOS installation ISO (make sure to use the ARM version).
- `sudo dd if=/dev/zero of=/dev/vda count=1 bs=512k`
- `sync`
- Clone this config somewhere inside `/tmp`.
- `nix-shell -p disko`
- `sudo disko --mode disko --flake .#vg001`
- `sudo nixos-install --no-channel-copy --no-root-password --flake .#vg001`
- Once the installation is done, boot into the newly-installed system.
- Set hashed user passwords (via `echo "PASSWORD" | mkpasswd -s`).
