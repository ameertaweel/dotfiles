{
  lib,
  config,
  pkgs,
  ...
}: let
  wrappedPkgs = import ./wrapped-pkgs.nix {
    inherit pkgs;
    inherit (config.custom.inputs) nix-wrapper-modules;
  };

  userSubmodule = {config, ...}: let
    cfg = config.custom.bash;
    bash = wrappedPkgs.bash;
  in {
    options = {
      custom.bash.enable = lib.mkOption {
        description = ''
            Enable Custom Bash
        '';
        type = lib.types.bool;
        default = false;
      };
      custom.bash.useAsLoginShell = lib.mkOption {
        description = ''
            Use Custom Bash as Login Shell
        '';
        type = lib.types.bool;
        default = false;
      };
    };

    config = lib.mkIf (cfg.enable != {}) {
      shell = lib.getExe bash;
      packages = [ bash ];
    };
  };
in {
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };
  };
}
