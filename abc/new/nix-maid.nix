{ lib, config, ... }:
let
  userSubmodule =
    { config, ... }:
    {
      config = lib.mkIf (config.isNormalUser) {
        maid = lib.mkDefault { };
      };
    };
in
{
  imports = [
    (import (import ./nix/tamal { }).nix-maid).nixosModules.default
  ];

  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };
  };
}
