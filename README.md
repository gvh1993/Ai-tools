# Ai-tools

Verzameling van eigen skills, instructies en hulpmiddelen voor AI-ondersteunde ontwikkeling (GitHub Copilot agent mode, Claude Code). Alles is generiek gehouden en bevat plaatshouders (`<zo-iets>`) die je per repo invult.

## Aan de slag

Installeer de skills in de repo waar je ze wilt gebruiken (de doelrepo). Het script kopieert ze, vult de plaatshouders in en commit niets.

```bash
git clone https://github.com/gvh1993/Ai-tools
cd Ai-tools

# macOS, Linux, WSL, Git Bash
./install.sh ../mijn-repo --ado-project "Mijn Project" --solution "Acme.Shop" --excluded-category "Slow" --templates --hooks
```

```powershell
# Windows PowerShell (nog niet op Windows getest)
.\install.ps1 ..\mijn-repo -AdoProject "Mijn Project" -Solution "Acme.Shop" -ExcludedCategory "Slow" -Templates -Hooks
```

| Optie | Betekenis |
| --- | --- |
| `--ado-project` / `-AdoProject` | Naam van het Azure DevOps-project |
| `--solution` / `-Solution` | Naam van de solution, zonder `.slnx` |
| `--excluded-category` / `-ExcludedCategory` | Testcategorie die de PR-pipeline uitsluit |
| `--target` / `-Target` | `copilot` (`.github/skills`), `claude` (`.claude/skills`) of `both` (standaard) |
| `--templates` / `-Templates` | Maak ook ontbrekende `.github/copilot-instructions.md`, `CLAUDE.md` en `.vscode/mcp.json` aan |
| `--hooks` / `-Hooks` | Installeer de Claude Code hooks in `.claude/hooks` en maak, als het nog niet bestaat, `.claude/settings.json` aan ([uitleg](hooks/README.md)) |
| `--force` / `-Force` | Overschrijf bestaande skills en hooks, bijvoorbeeld om een nieuwe versie te halen. Bestanden die van jou zijn (`docs/definition-of-done.md`, `.github/copilot-instructions.md`, `CLAUDE.md`, `.vscode/mcp.json`, `.claude/settings.json`) worden nooit overschreven |

Daarna:

1. **Loop de wijzigingen na** in de doelrepo (`git status`, `git diff`) en commit ze.
2. **Vul `.github/copilot-instructions.md` in.** De skills leunen hierop. Zie [`templates`](templates/README.md) voor een prompt waarmee een agent de eerste versie uit je code maakt.
3. **Start de MCP-server `ado`** (voorbeeld: [`templates/vscode-mcp.json`](templates/vscode-mcp.json)) en controleer dat de toolnamen die de skills noemen bij jouw versie passen.
4. **Doe een proefrun** op een klein, laag-risico item: `/ado-pickup 12345`. Pas de skill aan op wat er misgaat.
5. **Vul `docs/definition-of-done.md` aan** met de punten uit de `TODO`-lijst.
6. **Controleer de skills na elke wijziging** met de scenario's in [`evals`](evals/README.md).

Mist het script iets of draai je liever niets? Zie [Handmatig installeren](#handmatig-installeren).

## Inhoud

| Onderdeel | Wat het doet |
| --- | --- |
| [`ado-pickup`](.github/skills/ado-pickup/README.md) | `/ado-pickup`: Azure DevOps work items (Task, User Story) oppakken, grillen, implementeren in slices, PR voorbereiden en het item op On Hold met tag `PR` zetten. |
| [`ado-pickup-bugfix`](.github/skills/ado-pickup-bugfix/README.md) | `/ado-pickup-bugfix`: een Bug oppakken met oorzaak-onderzoek, eerst een falende reproductietest en een minimale fix. |
| [`ado-pr-followup`](.github/skills/ado-pr-followup/README.md) | `/ado-pr-followup`: reviewcomments en falende checks van een bestaande PR verwerken, zonder iets in ADO te schrijven. |
| [`ado-review`](.github/skills/ado-review/README.md) | `/ado-review`: een PR alleen-lezen beoordelen tegen de Definition of Done en je instructies; levert een reviewrapport als tekst. |
| [`ado-refine`](.github/skills/ado-refine/README.md) | `/ado-refine`: work items vóór de sprint verfijnen: vragen voor de PO, acceptatiecriteria, splitsingsvoorstel en Definition of Ready. |
| [`characterize-migrate`](.github/skills/characterize-migrate/README.md) | `/characterize-migrate`: bestaande code veilig migreren: eerst het gedrag vastleggen met karakteriseringstests, dan in kleine stappen verplaatsen. |
| [`adr`](.github/skills/adr/README.md) | `/adr`: een architectuurbeslissing vastleggen als ADR, met opties en gevolgen. Het besluit blijft van jou. |
| [`hooks`](hooks/README.md) | Claude Code hooks: blokkeer werk op `master`, riskante git-commando's en geheimen, en formatteer `.cs`-bestanden automatisch. |
| [`evals`](evals/README.md) | Scenario's en een scorecard om na elke wijziging aan een skill te controleren of hij nog doet wat hij moet doen, en laat wat hij moet laten. |
| [`templates`](templates/README.md) | Sjablonen voor `.github/copilot-instructions.md`, `CLAUDE.md`, `.vscode/mcp.json` en `.claude/settings.json`, plus een prompt om ze te laten invullen. |
| [`docs/definition-of-done.md`](docs/definition-of-done.md) | Definition of Done-checklist waar de skills tegen toetsen. Sjabloon om op je team af te stemmen. |

De ADO-skills sluiten op elkaar aan: `/ado-refine` vóór de sprint, `/ado-pickup` of `/ado-pickup-bugfix` tot en met de PR, `/ado-review` om de PR te laten beoordelen en `/ado-pr-followup` voor de reviewronde(s). `characterize-migrate` en `adr` staan los daarvan.

## Structuur

```
.github/
  skills/
    ado-pickup/          SKILL.md (wat de agent leest) en README.md (uitleg voor mensen)
    ado-pickup-bugfix/
    ado-pr-followup/
    ado-review/
    ado-refine/
    characterize-migrate/
    adr/
docs/
  definition-of-done.md
hooks/                   Scripts voor Claude Code hooks (guard-branch, guard-git, scan-secrets, format-dotnet)
evals/                   Scenario's per skill en een scorecard
templates/
  copilot-instructions.md
  CLAUDE.md
  vscode-mcp.json
  claude-settings.json
  README.md
install.sh               Installatiescript voor macOS, Linux, WSL, Git Bash
install.ps1              Installatiescript voor Windows PowerShell
```

Skills staan per map: `<skills-map>/<naam>/SKILL.md`, met bij voorkeur een eigen `README.md`.

## Naamgeving

Skills die tools van een bepaald systeem gebruiken heten `<systeem>-<skill>`, naar dat systeem: `ado-` voor Azure DevOps. Varianten voor andere systemen komen er naast te staan, bijvoorbeeld `gh-pickup` (GitHub Issues en PR's) of `jira-pickup`. Let op dat het ticketsysteem en de repo-host kunnen verschillen: `pickup` hangt af van het ticketsysteem, `pr-followup` en `review` van de plek waar de PR staat.

Skills die van geen enkel platform afhangen, zoals `adr` en `characterize-migrate`, krijgen geen prefix.

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
