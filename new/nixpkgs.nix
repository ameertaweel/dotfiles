{ lib, config, ... }:
let
  cnf = config.custom.nixpkgs;
in
{
  options = {
    custom.nixpkgs.channel = lib.mkOption {
      description = ''
        Nixpkgs channel.
      '';
      type = lib.types.package;
    };
  };

  config = {
    nixpkgs.flake.source = cnf.channel;
  };
}
