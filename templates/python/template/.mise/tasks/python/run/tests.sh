#!/usr/bin/env bash

#MISE description = "Run the tests with pytest"
#MISE depends = ["python:build"]

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

# pytest exits 5 when it collects no tests, which is where a new project starts.
status=0
uv run pytest || status=$?
if [ "$status" -eq 5 ]; then
	exit 0
fi
exit "$status"
