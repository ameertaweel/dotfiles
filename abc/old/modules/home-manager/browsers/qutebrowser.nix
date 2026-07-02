{
  lib,
  params,
  ...
}: let
  ifDefault = lib.mkIf (params.browser == "qutebrowser");
in {
  programs.qutebrowser.enable = true;

  xdg.mime.enable = ifDefault true;
  xdg.mimeApps.enable = ifDefault true;
  xdg.mimeApps.defaultApplications =
    ifDefault (import ./default-browser.nix "org.qutebrowser.qutebrowser");
}
