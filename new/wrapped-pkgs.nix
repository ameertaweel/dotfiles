{
  pkgs ? (import (import ./nix/tamal {}).nixpkgs {}),
  nix-wrapper-modules ? (import (import ./nix/tamal {}).nix-wrapper-modules { inherit pkgs; }),
}:

let
  callWrappedPkg = path: extraParams: import path (extraParams // { inherit nix-wrapper-modules pkgs; });
in {
  btop = callWrappedPkg ./btop.nix {};
  tealdeer = callWrappedPkg ./tealdeer.nix {};
  tmux = callWrappedPkg ./tmux {};
  vim = callWrappedPkg ./vim {};
  wezterm = callWrappedPkg ./wezterm {};
  bash = (import ./bash.nix { inherit nix-wrapper-modules; }).config.wrap({...}: {
    config.pkgs = pkgs;

    config.baseDirs.enable = true;
    config.userDirs.enable = true;
    config.userDirs.setSessionVariables = true;
  });
}
