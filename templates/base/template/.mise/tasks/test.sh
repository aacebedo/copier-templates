#!/usr/bin/env bash

#MISE description = "Run every template's <template>:test task"
# Each applied template ships its own <template>:test task (base:test always
# exists, so the pattern never matches nothing).
#MISE depends = ["*:test"]

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi
