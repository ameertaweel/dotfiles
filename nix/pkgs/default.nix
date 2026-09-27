# Custom packages, that can be defined similarly to ones from Nixpkgs
# You can build them using:
#   - New CLI: `nix build --file . packages.PACKAG_NAME`
#   - Old CLI: `nix-build . --attr packages.PACKAG_NAME`
{
  pkgs ? (import ../inputs.nix { }).pkgs,
  nix-wrapper-modules ? (import ../inputs.nix { }).nix-wrapper-modules,
  nix-jetbrains-plugins ? (import ../inputs.nix { }).nix-jetbrains-plugins,
}:
let
  wrapperToPkg =
    wrapper:
    wrapper.wrap (
      { ... }: {
        inherit pkgs;
      }
    );
  wrappers = import ./wrappers.nix {
    inherit nix-wrapper-modules nix-jetbrains-plugins;
  };
  wrappedPkgs = builtins.mapAttrs (k: v: wrapperToPkg v) wrappers;
in
{
  # example = pkgs.callPackage ./example { };
}
// wrappedPkgs
