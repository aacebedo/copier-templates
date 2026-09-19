#!/usr/bin/env bash

#MISE description = "Publish a release by running every template's <template>:release task"
# Each applied template may ship its own <template>:release task (base:release always
# exists, so the pattern never matches nothing).
#MISE depends = ["*:release"]

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi
