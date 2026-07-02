# Custom packages, that can be defined similarly to ones from Nixpkgs
# You can build them using:
#   - New CLI: `nix build --file . packages.PACKAG_NAME`
#   - Old CLI: `nix-build . --attr packages.PACKAG_NAME`
{
  pkgs ? (import ../nixpkgs.nix),
}:
{
  # example = pkgs.callPackage ./example { };
}
