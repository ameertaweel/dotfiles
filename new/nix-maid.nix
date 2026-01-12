{ lib, config, ... }: let
  userSubmodule =
    { config, ... }: {
      options = {
        custom.nixMaidUser = lib.mkOption {
          description = ''
            Enable nix-maid for the user.
          '';
          type = lib.types.bool;
          default = false;
        };
      };

      config = lib.mkIf (config.custom.nixMaidUser) {
        maid = {};
      };
    };

  nixMaidUsers = builtins.attrNames (
    lib.filterAttrs (user: userConfig: userConfig.custom.nixMaidUser) config.users.users
  );
  nixMaidUsersCount = builtins.length nixMaidUsers;

  cnf = config.custom.nixMaid;
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };

    custom.nixMaid.enable = lib.mkOption {
      description = ''
        Enables nix-maid on the system.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    assertions = [
      {
        assertion = cnf.enable -> (nixMaidUsersCount > 0);
        message = "nix-maid is enabled but no user is set as a nix-maid user.";
      }
      {
        assertion = (nixMaidUsersCount > 0) -> cnf.enable;
        message = "nix-maid is disabled but some user is set as a nix-maid user.";
      }
    ];

        imports = lib.mkIf (cnf.enable) [
          (import (import ./npins).nix-maid).nixosModules.default
        ];

  };
}
