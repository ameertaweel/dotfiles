{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (import ./nix/tamal {}) nix-index-database;
  packages = import nix-index-database { inherit pkgs; };

  cnf = config.custom.nix-index;
in
{
  options = {
    custom.nix-index.enable = lib.mkOption {
      description = ''
        Whether to enable `nix-index`, a file database for Nixpkgs.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf (cnf.enable) {
    programs.command-not-found.enable = false;

    programs.nix-index = {
      enable = true;
      package = packages.nix-index-with-db;
    };

    environment.systemPackages = [
      packages.comma-with-db
    ];
  };
}
