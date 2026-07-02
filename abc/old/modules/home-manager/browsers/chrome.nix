{
  lib,
  params,
  pkgs,
  ...
}: let
  ifDefault = lib.mkIf (builtins.elem params.browser ["chrome" "google-chrome"]);
in {
  # `google-chrome` is unfree
  imports = [../../nixpkgs-unfree.nix];

  home.packages = [pkgs.google-chrome];

  xdg.mime.enable = ifDefault true;
  xdg.mimeApps.enable = ifDefault true;
  xdg.mimeApps.defaultApplications =
    ifDefault (import ./default-browser.nix "google-chrome");
}
