{
  lib,
  params,
  pkgs,
  ...
}: let
  ifDefault = lib.mkIf (params.browser == "tor");
in {
  home.packages = [pkgs.tor-browser];

  xdg.mime.enable = ifDefault true;
  xdg.mimeApps.enable = ifDefault true;
  xdg.mimeApps.defaultApplications =
    ifDefault (import ./default-browser.nix "torbrowser");
}
