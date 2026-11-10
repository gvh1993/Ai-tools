#!/usr/bin/env bash
# PostToolUse-hook (Edit/Write/MultiEdit): past whitespace-opmaak toe op een gewijzigd .cs-bestand
# volgens de .editorconfig, met 'dotnet format whitespace --folder' (snel, laadt de solution niet).
# Faalt nooit en blokkeert nooit. Analyzer- en stijlregels controleer je nog steeds met 'dotnet format --verify-no-changes'.
# Uitzetten: SKIP_DOTNET_FORMAT=1
set -uo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
read_hook_input

[[ -n "${SKIP_DOTNET_FORMAT:-}" ]] && exit 0
command -v dotnet >/dev/null 2>&1 || exit 0

file="$(json_field file_path)"
[[ -n "$file" && "$file" == *.cs && -f "$file" ]] || exit 0

root="${CLAUDE_PROJECT_DIR:-$PWD}"
rel="${file#"$root"/}"
cd "$root" || exit 0

if ! dotnet format whitespace . --folder --include "$rel" >/dev/null 2>&1; then
  echo "dotnet format whitespace gaf een fout voor $rel (genegeerd)." >&2
fi
exit 0
