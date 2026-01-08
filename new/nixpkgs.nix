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

    custom.nixpkgs.allowUnfreePredicates = lib.mkOption {
      description = ''
        Predicates are joined and passed to `nixpkgs.config.allowUnfreePredicate`.
      '';
      type = lib.types.listOf (lib.types.functionTo lib.types.bool);
      default = [ ];
    };
  };

  config = {
    nixpkgs.flake.source = cnf.channel;
    nixpkgs.config.allowUnfreePredicate = (
      pkg: builtins.any (pred: pred pkg) cnf.allowUnfreePredicates
    );
  };
}
