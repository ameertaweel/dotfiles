let
  pkgs = import ./nix/nixpkgs.nix;

  # Custom packages, that can be defined similarly to ones from Nixpkgs
  # You can build them using:
  #   - New CLI: `nix build --file . packages.PACKAG_NAME`
  #   - Old CLI: `nix-build . --attr packages.PACKAG_NAME`
  packages = import ./nix/pkgs {
    inherit pkgs;
  };

  # Development Environment
  # You can activate it through:
  #   - New CLI: `nix develop --file shell.nix default`
  #   - Old CLI: `nix-shell -A default`
  devShells = import ./shell.nix {
    inherit pkgs;
  };

  # Custom packages and modifications, exported as overlays
  overlays = import ./nix/overlays;
in
{
  inherit packages devShells overlays;
}
