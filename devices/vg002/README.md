# My `vg002` Configuration

`vg002` is a Netcup VPS 1000 ARM G11.

## First-Time Install

- Upload SSH public key to Netcup's Server Control Panel (SCP).
- Initialize the VPS with any image available in the SCP. Make sure to use the
  uploaded SSH public key.
- Set `isBeforeInstall` to `true` in `./params.nix`.
- Execute `./install.sh`.
- Once the installation finishes, you have to access the VPS via Netcup's Server
  Control Panel (SCP).
- Unlock the ZFS dataset.
- Set `isBeforeInstall` to `false` in `./params.nix`.
- Execute `./deploy.sh`.
- Reboot the machine.
- Now you can unlock the VPS remotely via `./unlock.sh`.
