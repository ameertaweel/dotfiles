{ lib, config, ... }: {
  imports = [
    ./fg003
  ];

  options = {
    machines = lib.mkOption {
      type = lib.types.lazyAttrsOf config.types.machine;
    };
  };

  config =
    let
      globalConfig = config;
    in
    {
      types.machine = lib.types.submodule (
        { config, ... }: {
          imports = [
            globalConfig.nixosModules.nix-index
          ];

          options = {
            hostPlatform = lib.mkOption {
              type = lib.types.str;
            };

            nixpkgs.source = lib.mkOption {
              type = lib.types.package;
            };

            nixpkgs.pkgs = lib.mkOption {
              readOnly = true;
              apply =
                _:
                import config.nixpkgs.source {
                  config.allowUnfree = false;
                  overlays = [ ];
                };
            };

            nixosModules = lib.mkOption {
              type = lib.types.listOf lib.types.deferredModule;
            };

            nixosConfig = lib.mkOption {
              readOnly = true;
              apply =
                _:
                import (config.nixpkgs.source + "/nixos") {
                  configuration = { ... }: {
                    imports = config.nixosModules ++ [
                      {
                        nixpkgs.hostPlatform = config.hostPlatform;
                        nixpkgs.flake.source = config.nixpkgs.source;
                      }
                    ];
                  };
                  system = null;
                };
            };
          };
        }
      );
    };
}
