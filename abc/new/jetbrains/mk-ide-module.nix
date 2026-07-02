{
  ideName,
  ideDisplayName,
  unfree ? false,
}:
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
      cnf = config.custom.programs.jetbrains.${ideName};
    in
    {
      options = {
        custom.programs.jetbrains.${ideName} = {
          enable = lib.mkOption {
            description = ''
              Enable ${ideDisplayName} for the user.
            '';
            type = lib.types.bool;
            default = false;
          };

          ideaVIM.enable = lib.mkOption {
            description = ''
              Enable IdeaVIM plugin for ${ideDisplayName}.
            '';
            type = lib.types.bool;
            default = true;
          };

          plugins = lib.mkOption {
            description = ''
              ${ideDisplayName} plugins to install.
            '';
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
        };
      };

      config = lib.mkIf (cnf.enable) (
        let
          plugins = cnf.plugins ++ (if cnf.ideaVIM.enable then [ "IdeaVIM" ] else [ ]);
        in
        {
          packages = [
            (pkgs.custom.jetbrains.mkIDEWithPlugins ideName plugins)
          ];

          maid = lib.mkIf (cnf.ideaVIM.enable) (import ./ideavim { });
        }
      );
    };
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };
  };

  config = {
    nixpkgs.config.allowUnfreePackages =
      if unfree then
        [
          ideName
          "${ideName}-with-plugins"
        ]
      else
        [ ];
  };
}
