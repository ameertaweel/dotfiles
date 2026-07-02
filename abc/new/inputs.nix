{ lib, pkgs, ... }:
let
  sources = import ./nix/tamal { };
in
{
  options = {
    custom.sources = lib.mkOption {
      description = ''
        Input sources of this config.
      '';
      type = lib.types.attrsOf lib.types.package;
      default = { };
    };
    custom.inputs = lib.mkOption {
      description = ''
        Inputs of this config.
      '';
      type = lib.types.attrs;
      default = { };
    };
  };

  config = {
    custom.sources = sources;

    custom.inputs = {
      nix-jetbrains-plugins = import sources.nix-jetbrains-plugins;
      nix-wrapper-modules = import sources.nix-wrapper-modules { inherit pkgs; };
    };
  };
}
