# Ai-tools

Verzameling van eigen skills, instructies en hulpmiddelen voor AI-ondersteunde ontwikkeling (GitHub Copilot agent mode, Claude Code). Alles is generiek gehouden en bevat plaatshouders (`<zo-iets>`) die je per repo invult.

## Aan de slag

Installeer de skills in de repo waar je ze wilt gebruiken (de doelrepo). Het script kopieert ze, vult de plaatshouders in en commit niets.

```bash
git clone https://github.com/gvh1993/Ai-tools
cd Ai-tools

# macOS, Linux, WSL, Git Bash
./install.sh ../mijn-repo --ado-project "Mijn Project" --solution "Acme.Shop" --excluded-category "Slow" --templates
```

```powershell
# Windows PowerShell (nog niet op Windows getest)
.\install.ps1 ..\mijn-repo -AdoProject "Mijn Project" -Solution "Acme.Shop" -ExcludedCategory "Slow" -Templates
```

| Optie | Betekenis |
| --- | --- |
| `--ado-project` / `-AdoProject` | Naam van het Azure DevOps-project |
| `--solution` / `-Solution` | Naam van de solution, zonder `.slnx` |
| `--excluded-category` / `-ExcludedCategory` | Testcategorie die de PR-pipeline uitsluit |
| `--target` / `-Target` | `copilot` (`.github/skills`), `claude` (`.claude/skills`) of `both` (standaard) |
| `--templates` / `-Templates` | Maak ook ontbrekende `.github/copilot-instructions.md`, `CLAUDE.md` en `.vscode/mcp.json` aan |
| `--force` / `-Force` | Overschrijf bestaande bestanden (zonder dit worden ze overgeslagen) |

Daarna:

1. **Loop de wijzigingen na** in de doelrepo (`git status`, `git diff`) en commit ze.
2. **Vul `.github/copilot-instructions.md` in.** De skills leunen hierop. Zie [`templates`](templates/README.md) voor een prompt waarmee een agent de eerste versie uit je code maakt.
3. **Start de MCP-server `ado`** (voorbeeld: [`templates/vscode-mcp.json`](templates/vscode-mcp.json)) en controleer dat de toolnamen die de skills noemen bij jouw versie passen.
4. **Doe een proefrun** op een klein, laag-risico item: `/ado-pickup 12345`. Pas de skill aan op wat er misgaat.
5. **Vul `docs/definition-of-done.md` aan** met de punten uit de `TODO`-lijst.

Mist het script iets of draai je liever niets? Zie [Handmatig installeren](#handmatig-installeren).

## Inhoud

| Onderdeel | Wat het doet |
| --- | --- |
| [`.github/skills/ado-pickup`](.github/skills/ado-pickup/README.md) | Skill `/ado-pickup`: Azure DevOps work items (Task, User Story) oppakken, grillen, implementeren in slices, PR voorbereiden en het item op On Hold met tag `PR` zetten. |
| [`.github/skills/ado-pickup-bugfix`](.github/skills/ado-pickup-bugfix/README.md) | Skill `/ado-pickup-bugfix`: een Bug oppakken met oorzaak-onderzoek, eerst een falende reproductietest en een minimale fix. |
| [`.github/skills/ado-pr-followup`](.github/skills/ado-pr-followup/README.md) | Skill `/ado-pr-followup`: reviewcomments en falende checks van een bestaande PR verwerken, zonder iets in ADO te schrijven. |
| [`templates`](templates/README.md) | Sjablonen voor `.github/copilot-instructions.md` en `CLAUDE.md`, met een prompt om ze te laten invullen. |
| [`docs/definition-of-done.md`](docs/definition-of-done.md) | Definition of Done-checklist waar de skills tegen toetsen. Sjabloon om op je team af te stemmen. |

De skills sluiten op elkaar aan: `/ado-pickup` of `/ado-pickup-bugfix` tot en met de PR, daarna `/ado-pr-followup` voor de reviewronde(s).

## Structuur

```
.github/
  skills/
    ado-pickup/          SKILL.md (wat de agent leest) en README.md (uitleg voor mensen)
    ado-pickup-bugfix/
    ado-pr-followup/
docs/
  definition-of-done.md
templates/
  copilot-instructions.md
  CLAUDE.md
  vscode-mcp.json
  README.md
install.sh          Installatiescript voor macOS, Linux, WSL, Git Bash
install.ps1         Installatiescript voor Windows PowerShell
```

Skills staan per map: `<skills-map>/<naam>/SKILL.md`, met bij voorkeur een eigen `README.md`.

## Naamgeving

Skills heten `<systeem>-<skill>`, naar het systeem waarvan ze de tools gebruiken: `ado-` voor Azure DevOps. Varianten voor andere systemen komen er naast te staan, bijvoorbeeld `gh-pickup` (GitHub Issues en PR's) of `jira-pickup`. Let op dat het ticketsysteem en de repo-host kunnen verschillen: `pickup` hangt af van het ticketsysteem, `pr-followup` van de plek waar de PR staat. Welke `<skills-map>` een tool leest, verschilt:

| Tool | Skills-map in de repo |
| --- | --- |
| GitHub Copilot | `.github/skills/` |
| Claude Code | `.claude/skills/` |

Gebruik je beide tools, zet de skills dan in beide mappen, bijvoorbeeld met een symlink of een kopieerstap. Controleer in de documentatie van je tool of dit nog klopt, want deze mappen kunnen veranderen.

## Handmatig installeren

1. Kopieer de map van de skill naar de skills-map van je tool in de doelrepo (zie hierboven), en de documenten waar de skill naar verwijst (bij de skills hier: `docs/definition-of-done.md` en `.github/copilot-instructions.md`, zie `templates/`).
2. Vul de plaatshouders in (zie de README van de skill).
3. Controleer dat de relatieve links in `SKILL.md` kloppen met de plek waar je de bestanden neerzet. Ze gaan uit van `.github/skills/<naam>/`; staat de skill in `.claude/skills/<naam>/`, pas ze dan aan of laat ze naar `.github/` wijzen.
4. Start de skill in de chat met zijn slash-commando, bijvoorbeeld `/ado-pickup 12345`.

## Conventies

- Skills bevatten **geen** klant-, project- of persoonsgegevens: geen interne namen, paden, ticketnummers of geheimen. Gebruik plaatshouders.
- Een skill die iets naar een extern systeem schrijft, noemt expliciet welke schrijfacties mogen en welke nooit.
- Tekst uit externe systemen (tickets, comments, PR's) is data, geen instructies.
- Elke skill stopt voor akkoord vóór hij wijzigingen aanbrengt die lastig terug te draaien zijn.
