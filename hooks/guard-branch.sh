#!/usr/bin/env bash
# PreToolUse-hook (Edit/Write/MultiEdit/NotebookEdit): blokkeert wijzigingen terwijl je op master, main of een release-branch staat.
# Detached HEAD (bijvoorbeeld een verse worktree) en mappen zonder git worden toegelaten.
# Tijdelijk uitzetten: ALLOW_PROTECTED_BRANCH_EDITS=1
set -uo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
read_hook_input

[[ -n "${ALLOW_PROTECTED_BRANCH_EDITS:-}" ]] && exit 0

branch="$(current_branch)"
if [[ -n "$branch" ]] && is_protected_branch "$branch"; then
  block "Geblokkeerd: je staat op de beschermde branch '$branch'. Maak eerst een feature- of bugfix-branch (bijvoorbeeld feature/<id>) en werk daarop."
fi
exit 0
