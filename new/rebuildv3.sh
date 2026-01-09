NIX_CONFIG="extra-experimental-features = nix-command" nh os switch -f configuration.nix

sudo NIX_PATH="" nixos-rebuild --file configuration.nix boot
