#!/usr/bin/env bash

#MISE description = "Format the files the base template's tools cover"
#MISE hide = true

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

biome format --write .
tombi format
yamlfmt
rumdl fmt .
# The same file selection as the lint hook: tracked shell scripts only, never .venv/ or target/.
prek run shfmt --all-files
