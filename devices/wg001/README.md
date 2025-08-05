# Work Laptop

## Initial Setup

- Install a recent version of WSL.
- Create folder: `C:\WSL2-Distros`
- ~cd~ into folder: `C:\WSL2-Distros`
- Run PowerShell script: `.\create-nixos-wsl-distro.ps1 -DistroName nixos -NoRedownload`
- Enter WSL distro: `wsl -d nixos`
- Clone this repository to your home directory.
- `sudo nixos-rebuild switch -I nixos-config="${HOME}/dotfiles/devices/wg001/configuration.nix"`
