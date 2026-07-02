#!/usr/bin/env bash

# Safer Execution
set -Eeuo pipefail

################################################################################
# Command-Line Arguments
################################################################################

if [[ "${#}" -lt 2 ]]; then
	echo "Usage: ${0} <service> <executable> [args...]"
	exit 1
fi

SERVICE="${1}"
shift
EXECUTABLE="${1}"
shift
EXECUTABLE_ARGS=("${@}")

################################################################################
# Main
################################################################################

SERVICE_PID="$(systemctl show --property MainPID --value "${SERVICE}.service")"

exec sudo nsenter \
	--target "${SERVICE_PID}" \
	--all --env \
	--setuid follow --setgid follow \
	"$(command -v bash)" -c "
		export PATH=\"\${PATH}:${PATH}\"
		export TERM=\"${TERM}\"
		export PAGER=\"${PAGER}\"
		exec ${EXECUTABLE} ${EXECUTABLE_ARGS[*]}
	"
