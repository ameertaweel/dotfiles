{
  lib,
  config,
  pkgs,
  ...
}:
let
  userSubmodule =
    { config, ... }:
    {
      options = {
        custom.adbUser = lib.mkOption {
          description = ''
            Add the user to the `adbusers` group and install `android-tools` for
            the user.
          '';
          type = lib.types.bool;
          default = false;
        };
      };

      config = {
        extraGroups = lib.mkIf (config.custom.adbUser) [ "adbusers" ];
        packages = [
          pkgs.android-tools
        ];
      };
    };
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };
  };
}
