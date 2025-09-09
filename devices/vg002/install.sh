#!/usr/bin/env bash

# Safer Defaults
set -o errtrace
set -o errexit
set -o nounset
set -o pipefail

IS_BEFORE_INSTALL="$(nix eval --file ./params.nix isBeforeInstall)"

if [ "${IS_BEFORE_INSTALL}" != 'true' ]; then
	echo 'ERROR: `isBeforeInstall` must be set to `true`.'
	exit 1
fi

prompt_secret() {
	if [[ "${#}" -ne 2 ]]; then
		echo 'Usage: prompt_secret <prompt> <variable_name>' >&2
		return 1
	fi

	local prompt="${1}"
	local varname="${2}"
	local secret

	# Prompt silently (without echoing)
	read -r -s -p "${prompt} " secret
	echo

	# Set variable in caller's scope
	printf -v "${varname}" '%s' "${secret}"
}

DISK_ENCRYPTION_PWD=""

prompt_secret 'Enter Disk Encryption Password:' DISK_ENCRYPTION_PWD

HOSTNAME="$(nix eval --file ./params.nix hostname)"
HOSTNAME="${HOSTNAME:1:-1}"
FQDN="$(nix eval --file ./params.nix fqdn)"
FQDN="${FQDN:1:-1}"
DISK_ENCRYPTION_KEY_FILE="$(nix eval --file ./params.nix diskEncryptionKeyFile)"
DISK_ENCRYPTION_KEY_FILE="${DISK_ENCRYPTION_KEY_FILE:1:-1}"

nixos-anywhere \
	--flake ".#${HOSTNAME}" \
	--disk-encryption-keys "${DISK_ENCRYPTION_KEY_FILE}" <(printf '%s\n' "${DISK_ENCRYPTION_PWD}") \
	"root@${FQDN}"
