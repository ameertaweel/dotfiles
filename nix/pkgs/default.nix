# Custom packages, that can be defined similarly to ones from Nixpkgs
# You can build them using:
#   - New CLI: `nix build --file . packages.PACKAG_NAME`
#   - Old CLI: `nix-build . --attr packages.PACKAG_NAME`
{
  pkgs ? (import ../nixpkgs.nix { }),
  nix-wrapper-modules ? (import ../nix-wrapper-modules.nix { inherit pkgs; }),
}:
let
  wrapperToPkg =
    wrapper:
    wrapper.wrap (
      { ... }: {
        inherit pkgs;
      }
    );
  wrappers = import ./wrappers.nix { inherit nix-wrapper-modules; };
  wrappedPkgs = builtins.mapAttrs (k: v: wrapperToPkg v) wrappers;
in
{
  # example = pkgs.callPackage ./example { };
}
// wrappedPkgs
