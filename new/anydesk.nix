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
      cnf = config.custom.anydesk;
    in
    {
      options = {
        custom.anydesk.enable = lib.mkOption {
          description = ''
            Install AnyDesk for the user.
          '';
          type = lib.types.bool;
          default = false;
        };
      };

      config = lib.mkIf (cnf.enable) {
        packages = lib.mkIf (cnf.enable) [ pkgs.anydesk ];
      };
    };
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };
  };

  config = {
    custom.nixpkgs.allowUnfreePredicates = [
      (
        pkg:
        builtins.elem (lib.getName pkg) [
          "anydesk"
        ]
      )
    ];
  };
}
