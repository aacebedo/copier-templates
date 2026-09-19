#!/usr/bin/env bash

#MISE description = "Update the applied copier templates"

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

# Everything runs from main so bash has parsed the whole file before copier
# rewrites it: this script is itself one of the templated files.
main() {
	shopt -s nullglob
	local answers_files=(.copier-answers.*.yml) answers_file

	if [ "${#answers_files[@]}" -eq 0 ]; then
		printf "\033[31mNo copier template is applied - nothing to update.\033[0m\n" >&2
		exit 1
	fi

	# base must be updated first, as the other templates add to files it creates. The
	# glob sorts alphabetically, which holds as long as no template name sorts before base.
	for answers_file in "${answers_files[@]}"; do
		printf 'Updating %s\n' "$answers_file"
		# --defaults: keep the recorded answers, take the default for new questions.
		copier update --trust --defaults -a "$answers_file"

		local conflicts
		conflicts="$(git diff --name-only --diff-filter=U)"
		if [ -n "$conflicts" ]; then
			printf "\033[31mUpdating %s left conflicts to resolve:\033[0m\n%s\n" "$answers_file" "$conflicts" >&2
			exit 1
		fi
	done
}

main "$@"
