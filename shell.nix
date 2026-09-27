# Development Environment
# You can activate it through:
#   - New CLI: `nix develop --file shell.nix default`
#   - Old CLI: `nix-shell -A default`
{
  pkgs ? (import ./nix/inputs.nix { }).pkgs,
  nixhooks ? (import ./nix/inputs.nix { }).nixhooks,
}:
{
  default = pkgs.mkShell {
    nativeBuildInputs = [
      # This project uses Nixtamal for input pinning
      pkgs.nixtamal

      # Just command-runner
      pkgs.just

      # This project uses nixfmt for formatting
      pkgs.nixfmt
    ];

    shellHook =
      let
        hooks = nixhooks.mkHooks {
          hooks = {
            nixfmt-check = {
              entry = "${pkgs.nixfmt}/bin/nixfmt";
              args = [ "--check" ];
              files = "\\.nix$";
              exclude = "^nix/tamal";
            };
          };
        };
      in
      ''
        ${hooks.install-hooks}/bin/install-hooks
      '';
  };
}
