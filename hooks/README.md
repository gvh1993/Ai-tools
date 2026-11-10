# Hooks voor Claude Code

Hooks zijn scripts die Claude Code automatisch draait bij bepaalde acties. Ze dwingen af wat niet mag mislukken, ook als een instructie of skill vergeten wordt. Dat maakt ze betrouwbaarder dan regels in een Markdown-bestand.

Deze hooks werken alleen in **Claude Code**. De scripts zijn bash en hebben `bash` nodig (macOS, Linux, WSL of Git Bash). `jq` is optioneel; zonder `jq` valt de invoerverwerking terug op `sed`, wat voor gewone paden en commando's volstaat.

| Script | Wanneer | Wat het doet |
| --- | --- | --- |
| `guard-branch.sh` | Voor Edit/Write/MultiEdit/NotebookEdit | Blokkeert wijzigingen op `master`, `main` en `release*`. Detached HEAD (een verse worktree) en mappen zonder git mogen. |
| `guard-git.sh` | Voor Bash | Blokkeert force-push, push naar `master`/`main`/`release*`, een kale `git push` vanaf een beschermde branch, remote branches verwijderen, `reset --hard`, `clean -f`, `checkout -- .` en `branch -D`. |
| `scan-secrets.sh` | Voor Edit/Write/MultiEdit | Blokkeert tekst die op een geheim lijkt: wachtwoord in een connectionstring, account key, private key, AWS-key, JWT of een lange letterlijke `client_secret`/`api_key`/`token`. De waarde zelf wordt nooit getoond. |
| `format-dotnet.sh` | Na Edit/Write/MultiEdit | Past whitespace-opmaak toe op het gewijzigde `.cs`-bestand met `dotnet format whitespace --folder`. Snel en blokkeert nooit. |

`lib.sh` bevat de gedeelde hulpfuncties.

## Installeren

Met het installatiescript van deze repo:

```bash
./install.sh ../mijn-repo --hooks
```

Dat kopieert de scripts naar `.claude/hooks/` en zet `templates/claude-settings.json` als `.claude/settings.json`, als dat bestand nog niet bestaat. Bestaat het al, dan wordt het niet aangeraakt en moet je het `hooks`-blok uit het sjabloon er zelf in zetten. Controleer daarna met `/hooks` in Claude Code dat de hooks geladen zijn.

Handmatig: kopieer de map `hooks/` naar `.claude/hooks/` in je repo (en laat de scripts uitvoerbaar) en voeg het blok uit [`templates/claude-settings.json`](../templates/claude-settings.json) toe aan `.claude/settings.json`. Wil je ze alleen voor jezelf, zet het blok dan in `~/.claude/settings.json` of `.claude/settings.local.json`.

## Uitzetten

Per sessie, met een omgevingsvariabele:

| Variabele | Effect |
| --- | --- |
| `ALLOW_PROTECTED_BRANCH_EDITS=1` | `guard-branch.sh` laat alles toe |
| `SKIP_SECRET_SCAN=1` | `scan-secrets.sh` laat alles toe |
| `SKIP_DOTNET_FORMAT=1` | `format-dotnet.sh` doet niets |

`guard-git.sh` heeft geen schakelaar: vraag Claude het commando niet uit te voeren en draai het zelf in je terminal.

## Aandachtspunten

- Een blokkerende hook moet met **exit 2** eindigen. Exit 1 blokkeert niets; dat is een bekende valkuil.
- `scan-secrets.sh` is een vangnet met een paar patronen. Het vervangt geen echte scanner in je pijplijn.
- `format-dotnet.sh` regelt alleen whitespace uit de `.editorconfig`. Stijl- en analyzerregels controleer je nog met `dotnet format --verify-no-changes`, zoals de skills doen.
- `guard-git.sh` kijkt naar de tekst van het commando. Een commit-bericht dat een geblokkeerd commando letterlijk bevat, kan ten onrechte geblokkeerd worden.
- Hooks draaien met dezelfde rechten als Claude Code zelf. Installeer alleen hooks die je begrijpt.
