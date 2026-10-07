# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

let
  nixpkgsHostPlatform = "x86_64-linux";
  stateVersion = "25.11";
  fullName = "Ameer Taweel";

  sources = import ./nix/tamal {
    system = nixpkgsHostPlatform;
  };
  nixpkgsChannel = sources.nixpkgs;
in
(pkgs.lib.evalModules {
  modules = [
    ./fg003/default.nix
  ];
}).kyouma.machines
