#!/usr/bin/env bash

# Safer Defaults
set -o errtrace
set -o errexit
set -o nounset
set -o pipefail

FQDN="$(nix eval --file ./params.nix fqdn)"
FQDN="${FQDN:1:-1}"
SECRETS_DIR="$(nix eval --file ./params.nix secrets.dir)"
SECRETS_DIR="${SECRETS_DIR:1:-1}"

rsync -avL --chown=root:root --chmod=a-rwx,Du+rx,Fu+r secrets/ "root@${FQDN}:${SECRETS_DIR}"
