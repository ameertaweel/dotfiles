{ lib, config, ... }:
let
  cnf = config.custom.guix;
in
{
  options = {
    custom.guix.enable = lib.mkOption {
      description = ''
        Whether to enable the GNU Guix build daemon service.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf (cnf.enable) {
    services.guix = {
      enable = true;
      gc = {
        enable = true;
        dates = "weekly";
        extraArgs = [
          "--delete-generations=1m"
          "--vacuum-database"
        ];
      };
    };
  };
}
