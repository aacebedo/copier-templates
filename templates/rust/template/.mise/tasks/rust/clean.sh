#!/usr/bin/env bash

#MISE description = "Remove the Rust build output"
#MISE hide = true

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

rm -rf target
