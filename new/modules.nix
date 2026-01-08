{ ... }:
{
  imports = [
    ./nix-maid.nix
    ./nixpkgs.nix
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
  ];
}
