{
  lib,
  config,
  pkgs,
  ...
}:
let
  userSubmodule =
    { config, ... }:
    let
      vars = config.custom.sessionVariables;
    in
    {
      options = {
        custom.sessionVariables = lib.mkOption {
          description = ''
            User environment variables.
          '';
          type = lib.types.attrsOf lib.types.str;
        };
      };

      config = lib.mkIf (vars != { }) {
        maid = {
          file.home.".profile".text =
            let
              inherit (lib.strings) toShellVar;
              exportEnvVar = name: value: "export ${toShellVar name value}";
              lines = lib.attrsets.mapAttrsToList exportEnvVar vars;
            in
            builtins.concatStringsSep "\n" lines;
        };
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
