#!/usr/bin/env bash

#MISE description = "Build and smoke-test the site with a local server"
#MISE depends = ["hugo:build"]

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

npm --prefix tests install

cd src
hugo server --bind 0.0.0.0 --port 8080 --environment production --minify --disableLiveReload &
HUGO_PID=$!
trap 'kill "${HUGO_PID}" 2>/dev/null || true' EXIT

curl --retry 5 --retry-delay 5 --retry-all-errors --fail localhost:8080 >/dev/null

# Minimum Lighthouse score every category must reach: a floor to ratchet up, not a
# target.
node ../tests/lighthouse-check.mjs http://localhost:8080 90 ../.build/lighthouse
