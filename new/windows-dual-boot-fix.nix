{ lib, config, ... }:
let
  cnf = config.custom.windowsDualBootFix;
in
{
  options = {
    custom.windowsDualBootFix.enable = lib.mkOption {
      description = ''
        Whether to enable the GNU Guix build daemon service.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf (cnf.enable) {
    # Fix clock issue with Windows dual boot
    time.hardwareClockInLocalTime = lib.mkIf (cnf.enable) true;
  };
}
