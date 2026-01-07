{ lib, config, ... }:
let
  userSubmodule =
    { config, ... }:
    {
      options = {
        custom.podmanUser = lib.mkOption {
          description = ''
            Add the user to the `podman` group.
          '';
          type = lib.types.bool;
          default = false;
        };
      };

      config = {
        extraGroups = lib.mkIf (config.custom.podmanUser) [ "podman" ];
      };
    };

  podmanUsers = builtins.attrNames (
    lib.filterAttrs (user: userConfig: userConfig.custom.podmanUser) config.users.users
  );
  podmanUsersCount = builtins.length podmanUsers;

  cnf = config.custom.podman;
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };

    custom.podman.enable = lib.mkOption {
      description = ''
        Enables Podman on the system.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    warnings =
      if (cnf.enable && podmanUsersCount == 0) then
        [
          "Podman service is enabled but no user is set as a Podman user."
        ]
      else if (!cnf.enable && podmanUsersCount > 0) then
        [
          "Podman service is disabled but some user is set as a Podman user."
        ]
      else
        [
        ];

    virtualisation = (lib.mkIf cnf.enable) {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = false;
        # Required for containers under `podman-compose` to be able to talk to
        # each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
