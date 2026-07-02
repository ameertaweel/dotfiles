{ }:
let
  sources = import ./tamal { };

  overlays = import ./overlays;

  pkgs = import sources.nixpkgs {
    config.allowUnfree = false;
    overlays = [
      # Add overlays our own project exports (from overlays and pkgs dir):
      overlays.modifications
      overlays.additions
    ];
  };
in
pkgs
