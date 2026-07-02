{ lib, config, ... }:
let
  cnf = config.custom.profile.pc;
in
{
  options = {
    custom.profile.pc.enable = lib.mkOption {
      description = ''
        Whether to enable PC profile.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = (cnf.enable) {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
