{
  pkgs ? (import (import ./nix/tamal { }).nixpkgs { }),
  nix-wrapper-modules ? (import (import ./nix/tamal { }).nix-wrapper-modules { inherit pkgs; }),
}:

let
  callWrappedPkg =
    path: extraParams: import path (extraParams // { inherit nix-wrapper-modules pkgs; });
in
{
  wezterm = (callWrappedPkg ./wezterm { }).wrap (
    { ... }: {
      inherit pkgs;
    }
  );
  bash = (import ./bash.nix { inherit nix-wrapper-modules; }).config.wrap (
    { ... }: {
      config.pkgs = pkgs;
      config.bashrc = builtins.readFile ./bashrc.sh;
    }
  );
}
