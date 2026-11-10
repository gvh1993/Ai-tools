#!/usr/bin/env bash
# PreToolUse-hook (Edit/Write/MultiEdit): blokkeert het schrijven van wat op een geheim lijkt.
# Zoekt in de te schrijven tekst naar connectionstring-wachtwoorden, account keys, private keys,
# AWS-keys, JWT's en toewijzingen als client_secret/api_key/token met een lange letterlijke waarde.
# De gevonden waarde wordt nooit getoond. Het is een vangnet, geen volledige scanner.
# Tijdelijk uitzetten: SKIP_SECRET_SCAN=1
set -uo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
read_hook_input

[[ -n "${SKIP_SECRET_SCAN:-}" ]] && exit 0

# De hele hook-invoer bevat de te schrijven tekst (content, new_string, edits[].new_string).
text="$HOOK_INPUT"

check() { # check <omschrijving> <regex>
  if grep -Eiq -- "$2" <<< "$text"; then
    block "Geblokkeerd: de tekst bevat iets dat op een geheim lijkt ($1). Gebruik een plaatshouder, een omgevingsvariabele, user-secrets of Key Vault en probeer opnieuw."
  fi
}

check "wachtwoord in een connectionstring" '(Password|Pwd)[[:space:]]*=[[:space:]]*[^;[:space:]\\"<{$%*]{4,}'
check "storage account key" 'AccountKey=[A-Za-z0-9+/=]{20,}'
check "private key" '-----BEGIN ([A-Z]+ )?PRIVATE KEY-----'
check "AWS access key" 'AKIA[0-9A-Z]{16}'
check "JWT" 'eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.'
check "letterlijke secret/key/token" '(client_?secret|api_?key|access_?token|secret_?key|auth_?token)[\\"'"'"']*[[:space:]]*[:=][[:space:]]*[\\"'"'"']+[A-Za-z0-9/+_.-]{20,}[\\"'"'"']'
exit 0
