#!/usr/bin/env bash

#MISE description = "Check that the applied copier templates are up to date"

set -euo pipefail

if [ -z "${MISE_TASK_NAME:-}" ]; then
	printf "\033[31mError: this script must be run via 'mise run <task>' (not executed directly).\033[0m\n" >&2
	exit 1
fi

shopt -s nullglob
answers_files=(.copier-answers.*.yml)

if [ "${#answers_files[@]}" -eq 0 ]; then
	printf "\033[31mNo copier template is applied - run '%s'.\033[0m\n" "copier copy --trust -a .copier-answers.base.yml -d template=base gh:aacebedo/copier-templates ." >&2
	exit 1
fi

status=0
for answers_file in "${answers_files[@]}"; do
	name="${answers_file#.copier-answers.}"
	name="${name%.yml}"

	# Copier records the template version as `git describe --tags`; until the
	# templates repository has a release tag there is nothing to compare against.
	commit="$(sed -nE 's/^_commit: *//p' "$answers_file")"
	if [ -z "$commit" ]; then
		printf "\033[31m%s records no template version (_commit) in %s - update it with '%s'.\033[0m\n" \
			"$name" "$answers_file" "mise run update-templates" >&2
		status=1
		continue
	fi
	if ! [[ "$commit" =~ ^v?[0-9]+\.[0-9]+ ]]; then
		printf "\033[33mWarning: %s was applied from untagged template commit %s; skipping the update check.\033[0m\n" \
			"$name" "$commit" >&2
		continue
	fi

	# Exit status 2 means a newer template version is available.
	rc=0
	copier check-update --quiet -a "$answers_file" || rc=$?
	case "$rc" in
	0) ;;
	2)
		printf "\033[31m%s has a newer template version - run '%s'.\033[0m\n" \
			"$name" "mise run update-templates" >&2
		status=1
		;;
	*)
		printf "\033[31mCould not check %s for template updates (see above).\033[0m\n" "$name" >&2
		status=1
		;;
	esac
done

exit "$status"
