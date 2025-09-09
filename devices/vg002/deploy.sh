#!/usr/bin/env bash

# Safer Defaults
set -o errtrace
set -o errexit
set -o nounset
set -o pipefail

IS_BEFORE_INSTALL="$(nix eval --file ./params.nix isBeforeInstall)"

if [ "${IS_BEFORE_INSTALL}" != 'false' ]; then
	echo 'ERROR: `isBeforeInstall` must be set to `false`.'
	exit 1
fi

HOSTNAME="$(nix eval --file ./params.nix hostname)"
HOSTNAME="${HOSTNAME:1:-1}"
USERNAME="$(nix eval --file ./params.nix username)"
USERNAME="${USERNAME:1:-1}"
FQDN="$(nix eval --file ./params.nix fqdn)"
FQDN="${FQDN:1:-1}"

nixos-rebuild \
	--flake ".#${HOSTNAME}" \
	--build-host "${USERNAME}@${FQDN}" \
	--target-host "${USERNAME}@${FQDN}" \
	--sudo --no-reexec --ask-sudo-password --use-substitutes \
	boot
