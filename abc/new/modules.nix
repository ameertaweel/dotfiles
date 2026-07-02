{ ... }:
{
  imports = [
    ./nixpkgs.nix
    ./nix-maid.nix
    ./adb.nix
    ./docker.nix
    ./podman.nix
    ./guix.nix
    ./nix.nix
    ./virtual-box.nix
    # ./pc.nix
    # ./laptop.nix
    ./nix-index.nix
    ./anydesk.nix
    ./windows-dual-boot-fix.nix
    ./networking.nix
    ./jetbrains
    ./inputs.nix
    ./cli-essentials.nix
    ./bash-module.nix
    ./user-env-vars.nix
  ];
}
