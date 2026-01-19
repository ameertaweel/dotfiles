{ lib, pkgs, ... }:
let
  sources = import ./npins;
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
      wrappers = import sources.wrappers { inherit pkgs; };
    };
  };
}
