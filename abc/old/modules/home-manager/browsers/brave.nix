{
  lib,
  params,
  pkgs,
  ...
}: let
  ifDefault = lib.mkIf (builtins.elem params.browser ["brave" "brave-browser"]);
in {
  home.packages = [pkgs.brave];

  xdg.mime.enable = ifDefault true;
  xdg.mimeApps.enable = ifDefault true;
  xdg.mimeApps.defaultApplications =
    ifDefault (import ./default-browser.nix "brave-browser");
}
