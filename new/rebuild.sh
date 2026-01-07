#!/usr/bin/env bash

# Safer execution
set -Eeuo pipefail

COMMAND="${1}"       # `nixos-rebuild` command
CONFIGURATION="${2}" # `nixos-rebuild` config
CHANNEL_NAME="${3}"  # Nixpkgs channel

CHANNEL_PATH="$(
	nix-instantiate \
		--eval \
		--raw \
		--read-write-mode \
		--attr "${CHANNEL_NAME}.outPath" \
		npins/default.nix
)"

unset NIX_PATH
exec nixos-rebuild \
	-I nixpkgs="${CHANNEL_PATH}" \
	-I nixos-config="${CONFIGURATION}" \
	--no-reexec \
	"${COMMAND}" 

