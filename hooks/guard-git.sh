#!/usr/bin/env bash
# PreToolUse-hook (Bash): blokkeert riskante git-commando's.
#   - push met --force/-f, push naar master/main/release, push van een beschermde branch
#   - push --delete, reset --hard, clean -f, checkout -- ., branch -D
# Vraag de gebruiker het commando zelf uit te voeren als het echt nodig is.
set -uo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
read_hook_input

cmd="$(json_field command)"
[[ -z "$cmd" ]] && exit 0
# Alleen commando's met git erin zijn interessant.
[[ "$cmd" == *git* ]] || exit 0

if grep -Eq 'git[[:space:]]+push[^|;&]*([[:space:]]-[a-zA-Z]*f[a-zA-Z]*([[:space:]]|$)|--force)' <<< "$cmd"; then
  block "Geblokkeerd: force-push is niet toegestaan. Vraag de gebruiker dit zelf te doen als het echt nodig is."
fi
if grep -Eq 'git[[:space:]]+push[^|;&]*([[:space:]]|:)(master|main|release[/_-][^[:space:]]*|releases/[^[:space:]]*)([[:space:]]|$)' <<< "$cmd"; then
  block "Geblokkeerd: pushen naar master, main of een release-branch is niet toegestaan. Push een feature- of bugfix-branch en maak een PR."
fi
if grep -Eq 'git[[:space:]]+push[^|;&]*([[:space:]]--delete|[[:space:]]:[^[:space:]]+)' <<< "$cmd"; then
  block "Geblokkeerd: remote branches verwijderen is niet toegestaan zonder toestemming van de gebruiker."
fi
if grep -Eq 'git[[:space:]]+(reset[[:space:]]+--hard|clean[[:space:]]+-[a-zA-Z]*f|checkout[[:space:]]+--[[:space:]]+\.|branch[[:space:]]+-D)' <<< "$cmd"; then
  block "Geblokkeerd: dit commando kan werk onherstelbaar wissen (reset --hard, clean -f, checkout -- ., branch -D). Vraag de gebruiker om toestemming of om het zelf uit te voeren."
fi
# Een kale 'git push' (of push naar origin zonder branch) vanaf een beschermde branch.
if grep -Eq 'git[[:space:]]+push([[:space:]]+(-u|--set-upstream))?([[:space:]]+[^[:space:]-][^[:space:]]*)?[[:space:]]*($|[|;&])' <<< "$cmd"; then
  branch="$(current_branch)"
  if [[ -n "$branch" ]] && is_protected_branch "$branch"; then
    block "Geblokkeerd: je staat op de beschermde branch '$branch'. Pushen vanaf deze branch is niet toegestaan."
  fi
fi
exit 0
