{ lib, config, ... }:
let
  cnf = config.custom.profile.laptop;
in
{
  options = {
    custom.profile.laptop.enable = lib.mkOption {
      description = ''
        Whether to enable laptop profile.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = (cnf.enable) {
    custom.profile.pc.enable = true;

    # Enable touchpad support.
    # Enabled by default in most `desktopManager`.
    services.libinput.enable = true;
  };
}
