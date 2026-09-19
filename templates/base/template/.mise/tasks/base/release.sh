#!/usr/bin/env bash

#MISE description = "Bump the version with cog and publish a GitHub release"
#MISE hide = true

#MISE depends = ["lint"]

#MISE env = { GITHUB_TOKEN = { required = true, redact = true } }

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

cog bump --auto --skip-ci
