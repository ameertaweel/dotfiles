# Shell for bootstrapping flake-enabled nix and home-manager
# You can enter it through `nix develop`
{pkgs}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      just
      nixos-rebuild-summary
      nixos-anywhere
    ];
  };
  full = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      vim
      just
      nixos-rebuild-summary
    ];
  };
}
