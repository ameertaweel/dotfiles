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
        custom.dockerUser = lib.mkOption {
          description = ''
            Add the user to the `docker` group.

            **NOTE:** Beware that `docker` group membership is effectively
            equivalent to being root.
          '';
          type = lib.types.bool;
          default = false;
        };
      };

      config = lib.mkIf (config.custom.dockerUser) {
        extraGroups = [ "docker" ];
        packages = [ pkgs.lazydocker ];
      };
    };

  dockerUsers = builtins.attrNames (
    lib.filterAttrs (user: userConfig: userConfig.custom.dockerUser) config.users.users
  );
  dockerUsersCount = builtins.length dockerUsers;

  cnf = config.custom.docker;
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };

    custom.docker.enable = lib.mkOption {
      description = ''
        Enables Docker on the system.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    warnings =
      if (cnf.enable && dockerUsersCount == 0) then
        [
          "Docker service is enabled but no user is set as a Docker user."
        ]
      else if (!cnf.enable && dockerUsersCount > 0) then
        [
          "Docker service is disabled but some user is set as a Docker user."
        ]
      else
        [
        ];

    virtualisation.docker.enable = lib.mkIf (cnf.enable) true;
  };
}
