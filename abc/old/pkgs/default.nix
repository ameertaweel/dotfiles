# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using `nix build .#example`
{pkgs}: {
  # Fonts
  font-cairo = pkgs.callPackage ./fonts/cairo {};
  font-dubai = pkgs.callPackage ./fonts/dubai {};
  font-noto-sans-arabic = pkgs.callPackage ./fonts/noto-sans-arabic {};

  # Scripts
  nixos-rebuild-summary = pkgs.callPackage ./scripts/nixos-rebuild-summary {};
}
