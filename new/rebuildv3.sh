NIX_CONFIG="extra-experimental-features = nix-command" nh os switch -f configuration.nix

sudo NIX_PATH="" nixos-rebuild --log-format bar-with-logs --file configuration.nix boot
