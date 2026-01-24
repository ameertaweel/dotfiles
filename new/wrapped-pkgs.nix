{
  pkgs ? (import (import ./npins).nixpkgs-unstable {}),
  nix-wrapper-modules ? (import (import ./npins).nix-wrapper-modules-fork { inherit pkgs; }),
}:

let
  callWrappedPkg = path: extraParams: import path (extraParams // { inherit nix-wrapper-modules pkgs; });
in {
  btop = callWrappedPkg ./btop.nix {};
  tealdeer = callWrappedPkg ./tealdeer.nix {};
  tmux = callWrappedPkg ./tmux {};
  vim = callWrappedPkg ./vim {};
  wezterm = callWrappedPkg ./wezterm {};
}
