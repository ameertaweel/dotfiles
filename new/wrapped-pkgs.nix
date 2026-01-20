{
  pkgs ? (import (import ./npins).nixpkgs-unstable {}),
  nix-wrapper-modules ? (import (import ./npins).nix-wrapper-modules { inherit pkgs; }),
}:

let
  callWrappedPkg = path: extraParams: import path (extraParams // { inherit nix-wrapper-modules pkgs; });
in {
  btop = callWrappedPkg ./btop.nix {};
  tealdeer = callWrappedPkg ./tealdeer.nix {};
}
