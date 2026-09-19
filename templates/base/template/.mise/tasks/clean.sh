#!/usr/bin/env bash

#MISE description = "Remove generated files by running every template's <template>:clean task"
# Each applied template ships its own <template>:clean task (base:clean always
# exists, so the pattern never matches nothing).
#MISE depends = ["*:clean"]

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi
