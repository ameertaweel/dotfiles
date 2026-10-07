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
{
  # fg003 = import (nixpkgsChannel + "/nixos") {
  #   configuration = { ... }: {
  #     imports = [
  #       ./fg003/configuration.nix;
  #     ];
  #   };
  #   system = null;
  # };
}

# # This file defines custom overlays
# {
#   # This one brings our custom packages from the `pkgs` directory
#   additions = final: prev: {
#     custom = import ../pkgs { pkgs = final; };
#   };

#   # This one contains whatever you want to overlay
#   # You can change versions, add patches, set compilation flags, anything really.
#   # https://nixos.wiki/wiki/Overlays
#   modifications = final: prev: {
#     # example = prev.example.overrideAttrs (oldAttrs: rec {
#     # ...
#     # });
#   };
# }
