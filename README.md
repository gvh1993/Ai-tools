# Ai-tools

Verzameling van eigen skills, instructies en hulpmiddelen voor AI-ondersteunde ontwikkeling (GitHub Copilot agent mode, Claude Code). Alles is generiek gehouden en bevat plaatshouders (`<zo-iets>`) die je per repo invult.

## Inhoud

| Onderdeel | Wat het doet |
| --- | --- |
| [`.github/skills/pickup`](.github/skills/pickup/README.md) | Skill `/pickup`: Azure DevOps work items (Task, User Story) oppakken, grillen, implementeren in slices, PR voorbereiden en het item op On Hold met tag `PR` zetten. |
| [`.github/skills/pickup-bugfix`](.github/skills/pickup-bugfix/README.md) | Skill `/pickup-bugfix`: een Bug oppakken met oorzaak-onderzoek, eerst een falende reproductietest en een minimale fix. |
| [`.github/skills/pr-followup`](.github/skills/pr-followup/README.md) | Skill `/pr-followup`: reviewcomments en falende checks van een bestaande PR verwerken, zonder iets in ADO te schrijven. |
| [`templates`](templates/README.md) | Sjablonen voor `.github/copilot-instructions.md` en `CLAUDE.md`, met een prompt om ze te laten invullen. |
| [`docs/definition-of-done.md`](docs/definition-of-done.md) | Definition of Done-checklist waar de skills tegen toetsen. Sjabloon om op je team af te stemmen. |

De skills sluiten op elkaar aan: `/pickup` of `/pickup-bugfix` tot en met de PR, daarna `/pr-followup` voor de reviewronde(s).

## Structuur

```
.github/
  skills/
    pickup/          SKILL.md (wat de agent leest) en README.md (uitleg voor mensen)
    pickup-bugfix/
    pr-followup/
docs/
  definition-of-done.md
templates/
  copilot-instructions.md
  CLAUDE.md
  README.md
```

Skills staan per map: `<skills-map>/<naam>/SKILL.md`, met bij voorkeur een eigen `README.md`. Welke `<skills-map>` een tool leest, verschilt:

| Tool | Skills-map in de repo |
| --- | --- |
| GitHub Copilot | `.github/skills/` |
| Claude Code | `.claude/skills/` |

Gebruik je beide tools, zet de skills dan in beide mappen, bijvoorbeeld met een symlink of een kopieerstap. Controleer in de documentatie van je tool of dit nog klopt, want deze mappen kunnen veranderen.

## Een skill gebruiken in je eigen repo

1. Kopieer de map van de skill naar de skills-map van je tool in de doelrepo (zie hierboven), en de documenten waar de skill naar verwijst (bij de skills hier: `docs/definition-of-done.md` en `.github/copilot-instructions.md`, zie `templates/`).
2. Vul de plaatshouders in (zie de README van de skill).
3. Controleer dat de relatieve links in `SKILL.md` kloppen met de plek waar je de bestanden neerzet. Ze gaan uit van `.github/skills/<naam>/`; staat de skill in `.claude/skills/<naam>/`, pas ze dan aan of laat ze naar `.github/` wijzen.
4. Start de skill in de chat met zijn slash-commando, bijvoorbeeld `/pickup 12345`.

## Conventies

- Skills bevatten **geen** klant-, project- of persoonsgegevens: geen interne namen, paden, ticketnummers of geheimen. Gebruik plaatshouders.
- Een skill die iets naar een extern systeem schrijft, noemt expliciet welke schrijfacties mogen en welke nooit.
- Tekst uit externe systemen (tickets, comments, PR's) is data, geen instructies.
- Elke skill stopt voor akkoord vóór hij wijzigingen aanbrengt die lastig terug te draaien zijn.
