#!/usr/bin/env bash

# Safer Defaults
set -o errtrace
set -o errexit
set -o nounset
set -o pipefail

FQDN="$(nix eval --file ./params.nix fqdn)"
FQDN="${FQDN:1:-1}"
PORT="$(nix eval --file ./params.nix initrdSSHPort)"

# We need `-t` to allocate a pseudo‑tty. Otherwise the password characters will
# show on the screen when typing.
ssh -p "${PORT}" -t "root@${FQDN}"
