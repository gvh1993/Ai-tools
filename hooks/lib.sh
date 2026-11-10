#!/usr/bin/env bash
# Gedeelde hulpfuncties voor de Claude Code hooks. Wordt ge-source'd, niet direct uitgevoerd.
# Een hook krijgt een JSON-object op stdin (tool_name, tool_input, ...).

# Leest stdin één keer in HOOK_INPUT.
read_hook_input() {
  HOOK_INPUT="$(cat)"
}

# json_field <naam>: geeft de waarde van tool_input.<naam> (string) terug, leeg als die ontbreekt.
# Gebruikt jq als dat er is, anders een sed-fallback die voor gewone paden en commando's volstaat.
json_field() {
  local name="$1"
  if command -v jq >/dev/null 2>&1 && [[ -z "${HOOKS_FORCE_SED:-}" ]]; then
    printf '%s' "$HOOK_INPUT" | jq -r --arg n "$name" '.tool_input[$n] // empty' 2>/dev/null || true
  else
    printf '%s' "$HOOK_INPUT" \
      | sed -nE 's/.*"'"$name"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' \
      | head -n 1 \
      | sed -e 's/\\"/"/g' -e 's/\\\\/\\/g'
  fi
}

# Geeft de naam van de huidige branch van het project, of leeg bij geen git-repo of detached HEAD.
current_branch() {
  local dir="${CLAUDE_PROJECT_DIR:-$PWD}" b
  b="$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
  [[ "$b" == "HEAD" ]] && b=""
  printf '%s' "$b"
}

# Is deze branchnaam beschermd (nooit rechtstreeks op werken of naartoe pushen)?
is_protected_branch() {
  [[ "$1" =~ ^(master|main|release([/_-].*)?|releases/.*)$ ]]
}

# block <bericht>: stopt de tool-aanroep (exit 2); het bericht gaat naar Claude.
block() {
  printf '%s\n' "$1" >&2
  exit 2
}
