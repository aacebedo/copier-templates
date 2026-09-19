#!/usr/bin/env bash

#MISE description = "Update the applied copier templates, and apply the given ones for the first time"

#USAGE arg "[template]..." help="Templates to apply for the first time, e.g. base or hugo"

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

# Point at a local checkout while developing the templates themselves, e.g.
# COPIER_TEMPLATES_SRC=../copier-templates mise run apply-templates hugo
source="${COPIER_TEMPLATES_SRC:-gh:aacebedo/copier-templates}"

# base goes first: the other templates add to files it creates, never to each other's.
ordered() {
	local name
	for name in "$@"; do [ "$name" != base ] || echo base; done
	for name in "$@"; do [ "$name" = base ] || echo "$name"; done
}

shopt -s nullglob
applied=()
for answers_file in .copier-answers.*.yml; do
	name="${answers_file#.copier-answers.}"
	applied+=("${name%.yml}")
done

if [ "${#applied[@]}" -gt 0 ]; then
	while read -r name; do
		printf 'Updating %s (.copier-answers.%s.yml)\n' "$name" "$name"
		copier update --trust -a ".copier-answers.${name}.yml"
	done < <(ordered "${applied[@]}")
fi

if [ "$#" -gt 0 ]; then
	while read -r name; do
		answers_file=".copier-answers.${name}.yml"
		if [ -f "$answers_file" ]; then
			printf '%s is already applied (%s)\n' "$name" "$answers_file"
			continue
		fi
		printf 'Applying %s for the first time (%s)\n' "$name" "$answers_file"
		copier copy --trust -a "$answers_file" -d template="$name" "$source" .
	done < <(ordered "$@")
fi
