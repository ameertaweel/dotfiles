let
  sources = import ./nixtamal { };

  overlays = import ./overlays;

  pkgs = import sources.nixpkgs {
    config.allowUnfree = false;
    overlays = [
      # Add overlays our own project exports (from overlays and pkgs dir):
      overlays.modifications
      overlays.additions
    ];
  };

  nix-wrapper-modules = import sources.nix-wrapper-modules {
    inherit pkgs;
  };

  nix-jetbrains-plugins = import sources.nix-jetbrains-plugins;
in
{
  inherit
    pkgs
    nix-wrapper-modules
    nix-jetbrains-plugins
    nixhooks
    ;
}
