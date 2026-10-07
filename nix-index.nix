{
  lib,
  config,
  ...
}:
let
  cfg = config.nix-index;
in
{
  options.nix-index = {
    # TODO: Use `lib.mkEnableOption`
    enable = lib.mkOption {
      description = ''
        Whether to enable `nix-index`, a file database for Nixpkgs.
      '';
      type = lib.types.bool;
      default = false;
    };

    source = lib.mkOption {
      type = lib.types.package;
    };

    pkgs = lib.mkOption {
      readOnly = true;
      apply =
        _:
        import cfg.source {
          inherit (config.nixpkgs) pkgs;
        };
    };
  };

  config.nixosModules = lib.mkIf cfg.enable [
    {
      programs.command-not-found.enable = false;

      programs.nix-index = {
        enable = true;
        package = cfg.pkgs.nix-index-with-db;
      };

      environment.systemPackages = [
        cfg.pkgs.comma-with-db
      ];
    }
  ];
}
