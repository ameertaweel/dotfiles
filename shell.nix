# Development Environment
# You can activate it through:
#   - New CLI: `nix develop --file shell.nix default`
#   - Old CLI: `nix-shell -A default`
{
  pkgs ? (import ./nix/nixpkgs.nix),
}:
{
  default = pkgs.mkShell {
    nativeBuildInputs = [
      # This project uses Nixtamal for input pinning
      pkgs.nixtamal
    ];
  };
}
