{
  lib,
  params,
  ...
}: let
  ifDefault = lib.mkIf (params.browser == "firefox");
in {
  programs.firefox.enable = true;

  xdg.mime.enable = ifDefault true;
  xdg.mimeApps.enable = ifDefault true;
  xdg.mimeApps.defaultApplications =
    ifDefault (import ./default-browser.nix "firefox");
}
