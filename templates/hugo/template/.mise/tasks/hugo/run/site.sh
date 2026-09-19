#!/usr/bin/env bash

#MISE description = "Serve the site locally"
#MISE depends = ["hugo:build"]

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

cd src
hugo server --bind 0.0.0.0 --port 8080
