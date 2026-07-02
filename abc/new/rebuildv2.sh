#!/usr/bin/env bash

# Safer execution
set -Eeuo pipefail

CONFIGURATION="${1}" # `nixos-rebuild` config

# CHANNEL_PATH="$(
# 	nix-instantiate \
# 		--eval \
# 		--raw \
# 		--read-write-mode \
# 		--attr "${CHANNEL_NAME}.outPath" \
# 		npins/default.nix
# )"

unset NIX_PATH
nix-build --attr config.system.build.vm "${CONFIGURATION}"

