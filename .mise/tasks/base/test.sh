#!/usr/bin/env bash

#MISE description = "Nothing to test for the base template"
#MISE hide = true
# Only here so that the test task's *:test pattern always matches.

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi
