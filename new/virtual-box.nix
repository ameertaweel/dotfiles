{
  lib,
  config,
  options,
  ...
}:
let
  userSubmodule =
    { config, ... }:
    {
      options = {
        custom.virtualBoxUser = lib.mkOption {
          description = ''
            Add the user to the `vboxusers` group.
          '';
          type = lib.types.bool;
          default = false;
        };
      };

      config = {
        extraGroups = lib.mkIf (config.custom.virtualBoxUser) [ "vboxusers" ];
      };
    };

  virtualBoxUsers = builtins.attrNames (
    lib.filterAttrs (user: userConfig: userConfig.custom.virtualBoxUser) config.users.users
  );
  virtualBoxUsersCount = builtins.length virtualBoxUsers;

  cnf = config.custom.virtualBox;
  opt = options.custom.virtualBox;
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };

    custom.virtualBox.enable = lib.mkOption {
      description = ''
        Enables VirtualBox on the system.
      '';
      type = lib.types.bool;
      default = false;
    };

    custom.virtualBox.headless = lib.mkOption {
      description = ''
        VirtualBox installation without GUI dependencies.
      '';
      type = lib.types.bool;
    };
  };

  config = {
    assertions = [
      {
        assertion = cnf.enable -> opt.headless.isDefined;
        message = "Option `custom.virtualBox.headless` is required.";
      }
    ];

    warnings =
      if (cnf.enable && virtualBoxUsersCount == 0) then
        [
          "VirtualBox service is enabled but no user is set as a VirtualBox user."
        ]
      else if (!cnf.enable && virtualBoxUsersCount > 0) then
        [
          "VirtualBox service is disabled but some user is set as a VirtualBox user."
        ]
      else
        [
        ];

    virtualisation.virtualbox.host = lib.mkIf (cnf.enable) {
      enable = true;
      enableExtensionPack = true;
      headless = lib.mkIf opt.headless.isDefined cnf.headless;
    };

    custom.nixpkgs.allowUnfreePredicates = [
      (
        pkg:
        builtins.elem (lib.getName pkg) [
          "Oracle_VirtualBox_Extension_Pack"
        ]
      )
    ];
  };
}
