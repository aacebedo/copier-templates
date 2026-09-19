#!/usr/bin/env bash

#MISE description = "Remove the Hugo build output and the npm tree the tests install"
#MISE hide = true

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

rm -rf .build src/.hugo_build.lock tests/node_modules tests/package-lock.json
