#!/usr/bin/env bash

#MISE description = "Build and test the Python project"
#MISE hide = true
#MISE depends = ["python:run:tests"]

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi
