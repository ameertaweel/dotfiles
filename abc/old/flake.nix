{
  description = "My Personal Dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        # config.allowUnfree = true;
        overlays = [
          # Add overlays our own flake exports (from overlays and pkgs dir):
          outputs.overlays.modifications
          outputs.overlays.additions
        ];
      };
  in {
    # Custom packages
    # Acessible through `nix build` and `nix shell`
    packages = forAllSystems (system:
      import ./pkgs {
        pkgs = mkPkgs system;
      });
    # Development environment
    # Acessible through `nix develop`
    devShells = forAllSystems (system:
      import ./shell.nix {
        pkgs = mkPkgs system;
      });

    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays;

    # Nix files formatter (alejandra, nixfmt or nixpkgs-fmt)
    # Run with `nix fmt`
    formatter = forAllSystems (
      system: let
        pkgs = mkPkgs system;
      in
        pkgs.alejandra
    );
  };
}
