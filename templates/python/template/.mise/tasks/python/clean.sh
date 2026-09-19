#!/usr/bin/env bash

#MISE description = "Remove the Python virtual environment and tool caches"
#MISE hide = true

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

rm -rf .venv .pytest_cache .ruff_cache
