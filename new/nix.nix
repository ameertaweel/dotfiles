{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;

    channel.enable = false;

    settings = {
      # Enable experimental features (flakes, new `nix` commands, and content-addressed nix)
      experimental-features = "nix-command flakes ca-derivations auto-allocate-uids";

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      # Automatically pick UIDs for builds, rather than creating nixbld* user accounts
      auto-allocate-uids = true;

      # Flag problematic path and URL literals
      # Helps avoid non-portable builds
      lint-url-literals = "fatal";
      # TODO: Set to `fatal` after eliminating all warnings.
      lint-short-path-literals = "warn";
      # TODO: Set to `fatal` after eliminating all warnings.
      lint-absolute-path-literals = "warn";
    };

    # Auto garbage-collection to save disk space
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
