{
  pkgs ? (import ./nixpkgs.nix { }),
}:
let
  sources = import ./tamal { };

  nix-wrapper-modules = import sources.nix-wrapper-modules {
    inherit pkgs;
  };
in
nix-wrapper-modules
