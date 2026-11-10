#!/usr/bin/env bash
# Installeert de skills uit deze repo in een doelrepo en vult de plaatshouders in.
# Gebruik: ./install.sh <doelrepo> [opties]   (zie --help)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Gebruik: install.sh <doelrepo> [opties]

Kopieert de skills naar de doelrepo en vult de plaatshouders in.

Opties:
  --ado-project <naam>            Vult <ado-project> in
  --solution <naam>               Vult <solution> in (zonder .slnx)
  --excluded-category <naam>      Vult <excluded-category> in
  --target <copilot|claude|both>  Waar de skills komen: .github/skills, .claude/skills of beide (standaard: both)
  --templates                     Maak ook ontbrekende bestanden aan: .github/copilot-instructions.md,
                                  CLAUDE.md en .vscode/mcp.json
  --hooks                         Installeer de Claude Code hooks in .claude/hooks en maak, als dat nog niet
                                  bestaat, .claude/settings.json aan
  --force                         Overschrijf bestaande skills en hooks (bijv. om een nieuwe versie te halen)
  -h, --help                      Toon deze hulp

Bestanden die van jou zijn worden nooit overschreven, ook niet met --force: docs/definition-of-done.md,
.github/copilot-instructions.md, CLAUDE.md, .vscode/mcp.json en .claude/settings.json.
Er wordt niets gecommit.
EOF
}

TARGET_REPO=""
ADO_PROJECT=""
SOLUTION=""
EXCLUDED_CATEGORY=""
TARGET="both"
WITH_TEMPLATES=0
WITH_HOOKS=0
FORCE=0

need_value() {
  if [[ $# -lt 2 || -z "${2:-}" ]]; then
    echo "Fout: $1 heeft een waarde nodig." >&2
    exit 2
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ado-project) need_value "$@"; ADO_PROJECT="$2"; shift 2 ;;
    --solution) need_value "$@"; SOLUTION="$2"; shift 2 ;;
    --excluded-category) need_value "$@"; EXCLUDED_CATEGORY="$2"; shift 2 ;;
    --target) need_value "$@"; TARGET="$2"; shift 2 ;;
    --templates) WITH_TEMPLATES=1; shift ;;
    --hooks) WITH_HOOKS=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Fout: onbekende optie $1" >&2; usage >&2; exit 2 ;;
    *)
      if [[ -n "$TARGET_REPO" ]]; then
        echo "Fout: meerdere doelrepo's opgegeven." >&2
        exit 2
      fi
      TARGET_REPO="$1"; shift ;;
  esac
done

if [[ -z "$TARGET_REPO" ]]; then
  usage >&2
  exit 2
fi

case "$TARGET" in
  copilot|claude|both) ;;
  *) echo "Fout: --target moet copilot, claude of both zijn." >&2; exit 2 ;;
esac

if [[ ! -d "$TARGET_REPO" ]]; then
  echo "Fout: doelmap bestaat niet: $TARGET_REPO" >&2
  exit 1
fi
TARGET_REPO="$(cd "$TARGET_REPO" && pwd)"

if [[ "$TARGET_REPO" == "$SCRIPT_DIR" ]]; then
  echo "Fout: de doelrepo is dezelfde als de bronrepo." >&2
  exit 1
fi

if [[ ! -d "$TARGET_REPO/.git" ]]; then
  echo "Let op: $TARGET_REPO lijkt geen git-repo (geen .git gevonden). Ik ga toch door."
fi

# Maakt een waarde veilig voor gebruik in de vervangtekst van sed.
esc() { printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'; }

# Vult de plaatshouders in de bestanden waar ze bedoeld zijn (niet in de README's, daar worden ze uitgelegd).
fill_placeholders() {
  local path="$1" args=() f tmp
  [[ -n "$ADO_PROJECT" ]] && args+=(-e "s|<ado-project>|$(esc "$ADO_PROJECT")|g")
  [[ -n "$SOLUTION" ]] && args+=(-e "s|<solution>|$(esc "$SOLUTION")|g")
  [[ -n "$EXCLUDED_CATEGORY" ]] && args+=(-e "s|<excluded-category>|$(esc "$EXCLUDED_CATEGORY")|g")
  [[ ${#args[@]} -eq 0 ]] && return 0
  while IFS= read -r -d '' f; do
    tmp="$(mktemp)"
    sed "${args[@]}" "$f" > "$tmp"
    cat "$tmp" > "$f"
    rm -f "$tmp"
  done < <(find "$path" -type f \( -name 'SKILL.md' -o -name 'definition-of-done.md' -o -name 'copilot-instructions.md' \) -print0)
}

INSTALLED=()
SKIPPED=()

copy_dir() {
  local src="$1" dst="$2"
  if [[ -e "$dst" ]]; then
    if [[ $FORCE -eq 0 ]]; then
      SKIPPED+=("$dst")
      return 1
    fi
    rm -rf "$dst"
  fi
  mkdir -p "$(dirname "$dst")"
  cp -R "$src" "$dst"
  INSTALLED+=("$dst")
}

# copy_file <bron> <doel> [keep]: met 'keep' wordt een bestaand bestand nooit overschreven (ook niet met --force).
copy_file() {
  local src="$1" dst="$2" keep="${3:-}"
  if [[ -e "$dst" && ( $FORCE -eq 0 || -n "$keep" ) ]]; then
    SKIPPED+=("$dst")
    return 1
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  INSTALLED+=("$dst")
}

# Skills
dests=()
[[ "$TARGET" == "copilot" || "$TARGET" == "both" ]] && dests+=("$TARGET_REPO/.github/skills")
[[ "$TARGET" == "claude" || "$TARGET" == "both" ]] && dests+=("$TARGET_REPO/.claude/skills")

found=0
for skill_dir in "$SCRIPT_DIR"/.github/skills/*/; do
  [[ -f "${skill_dir}SKILL.md" ]] || continue
  found=1
  name="$(basename "$skill_dir")"
  for dest in "${dests[@]}"; do
    if copy_dir "${skill_dir%/}" "$dest/$name"; then
      fill_placeholders "$dest/$name"
      # In .claude/skills staat de skill een niveau anders dan in .github/skills: pas de link naar de instructies aan.
      if [[ "$dest" == "$TARGET_REPO/.claude/skills" ]]; then
        while IFS= read -r -d '' f; do
          tmp="$(mktemp)"
          sed -e 's|\.\./\.\./copilot-instructions\.md|../../../.github/copilot-instructions.md|g' "$f" > "$tmp"
          cat "$tmp" > "$f"
          rm -f "$tmp"
        done < <(find "$dest/$name" -type f -name '*.md' -print0)
      fi
    fi
  done
done

if [[ $found -eq 0 ]]; then
  echo "Fout: geen skills gevonden in $SCRIPT_DIR/.github/skills" >&2
  exit 1
fi

# Definition of Done
if copy_file "$SCRIPT_DIR/docs/definition-of-done.md" "$TARGET_REPO/docs/definition-of-done.md" keep; then
  fill_placeholders "$TARGET_REPO/docs/definition-of-done.md"
fi

# Sjablonen
if [[ $WITH_TEMPLATES -eq 1 ]]; then
  if copy_file "$SCRIPT_DIR/templates/copilot-instructions.md" "$TARGET_REPO/.github/copilot-instructions.md" keep; then
    fill_placeholders "$TARGET_REPO/.github/copilot-instructions.md"
  fi
  copy_file "$SCRIPT_DIR/templates/CLAUDE.md" "$TARGET_REPO/CLAUDE.md" keep || true
  copy_file "$SCRIPT_DIR/templates/vscode-mcp.json" "$TARGET_REPO/.vscode/mcp.json" keep || true
fi

# Hooks (Claude Code)
SETTINGS_EXISTS=0
if [[ $WITH_HOOKS -eq 1 ]]; then
  for h in "$SCRIPT_DIR"/hooks/*.sh; do
    [[ -f "$h" ]] || continue
    if copy_file "$h" "$TARGET_REPO/.claude/hooks/$(basename "$h")"; then
      chmod +x "$TARGET_REPO/.claude/hooks/$(basename "$h")"
    fi
  done
  if [[ -e "$TARGET_REPO/.claude/settings.json" ]]; then
    SETTINGS_EXISTS=1
    SKIPPED+=("$TARGET_REPO/.claude/settings.json")
  else
    copy_file "$SCRIPT_DIR/templates/claude-settings.json" "$TARGET_REPO/.claude/settings.json" keep || true
  fi
fi

echo "Geïnstalleerd in $TARGET_REPO:"
if [[ ${#INSTALLED[@]} -gt 0 ]]; then
  for p in "${INSTALLED[@]}"; do echo "  + ${p#"$TARGET_REPO"/}"; done
else
  echo "  (niets nieuw)"
fi
if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo "Overgeslagen omdat ze al bestaan (skills en hooks overschrijf je met --force; de rest nooit):"
  for p in "${SKIPPED[@]}"; do echo "  = ${p#"$TARGET_REPO"/}"; done
fi

# Plaatshouders die nog openstaan (alleen in de bestanden waar ze ingevuld horen te zijn)
remaining=""
for p in "${INSTALLED[@]:-}"; do
  [[ -n "$p" && -e "$p" ]] || continue
  while IFS= read -r -d '' f; do
    if grep -qE '<(ado-project|solution|excluded-category)>' "$f"; then
      remaining+="$f"$'\n'
    fi
  done < <(find "$p" -type f \( -name 'SKILL.md' -o -name 'definition-of-done.md' -o -name 'copilot-instructions.md' \) -print0)
done
remaining="$(printf '%s' "$remaining" | sed '/^$/d' | sort -u)"
if [[ -n "$remaining" ]]; then
  names="$(while IFS= read -r f; do grep -ohE '<(ado-project|solution|excluded-category)>' "$f"; done <<< "$remaining" | sort -u | tr '\n' ' ')"
  echo
  echo "Nog niet ingevuld: ${names}"
  echo "Gebruik de opties --ado-project, --solution en --excluded-category (met --force), of vul ze met de hand in. Aanwezig in:"
  while IFS= read -r f; do echo "  ${f#"$TARGET_REPO"/}"; done <<< "$remaining"
fi

if [[ $SETTINGS_EXISTS -eq 1 ]]; then
  echo
  echo "Let op: .claude/settings.json bestaat al en is niet aangepast. Voeg het blok \"hooks\" uit templates/claude-settings.json zelf toe."
fi

cat <<'EOF'

Volgende stappen:
  1. Controleer .github/copilot-instructions.md (sjabloon: templates/copilot-instructions.md) en vul docs/definition-of-done.md aan.
  2. Start de MCP-server 'ado' (sjabloon: templates/vscode-mcp.json) en controleer de toolnamen.
  3. Doe een proefrun op een klein item, bijvoorbeeld: /ado-pickup 12345
EOF
