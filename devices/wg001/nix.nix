{
  config,
  lib,
  ...
}: {
  nix = {
    settings = {
      # Enable experimental features (flakes, new `nix` commands, and content-addressed nix)
      experimental-features = "nix-command flakes ca-derivations auto-allocate-uids";

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      # Automatically pick UIDs for builds, rather than creating nixbld* user accounts
      auto-allocate-uids = true;
    };

    # Auto garbage-collection to save disk space
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
