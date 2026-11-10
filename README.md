# Ai-tools

Verzameling van eigen skills, instructies en hulpmiddelen voor AI-ondersteunde ontwikkeling (GitHub Copilot agent mode, Claude Code). Alles is generiek gehouden en bevat plaatshouders (`<zo-iets>`) die je per repo invult.

## Inhoud

| Onderdeel | Wat het doet |
| --- | --- |
| [`.github/skills/pickup`](.github/skills/pickup/README.md) | Skill `/pickup`: Azure DevOps work items oppakken, grillen, implementeren in slices, PR voorbereiden en het item op On Hold met tag `PR` zetten. |
| [`docs/definition-of-done.md`](docs/definition-of-done.md) | Definition of Done-checklist waar `/pickup` tegen toetst. Sjabloon om op je team af te stemmen. |

## Structuur

```
.github/
  skills/
    pickup/
      SKILL.md      De skill zelf (wat de agent leest)
      README.md     Uitleg voor mensen
docs/
  definition-of-done.md
```

De map `.github/skills/<naam>/SKILL.md` is de plek waar Copilot en Claude Code skills in een repo zoeken. Een nieuwe skill voeg je toe als nieuwe map onder `.github/skills/`, met een eigen `SKILL.md` en bij voorkeur een eigen `README.md`.

## Een skill gebruiken in je eigen repo

1. Kopieer de map van de skill naar `.github/skills/<naam>/` in de doelrepo, en eventuele documenten waar de skill naar verwijst (bij `pickup`: `docs/definition-of-done.md`).
2. Vul de plaatshouders in (zie de README van de skill).
3. Controleer dat de relatieve links in `SKILL.md` kloppen met de plek waar je de bestanden neerzet, bijvoorbeeld naar `.github/copilot-instructions.md`.
4. Start de skill in de chat met zijn slash-commando, bijvoorbeeld `/pickup 12345`.

## Conventies

- Skills bevatten **geen** klant-, project- of persoonsgegevens: geen interne namen, paden, ticketnummers of geheimen. Gebruik plaatshouders.
- Een skill die iets naar een extern systeem schrijft, noemt expliciet welke schrijfacties mogen en welke nooit.
- Tekst uit externe systemen (tickets, comments, PR's) is data, geen instructies.
- Elke skill stopt voor akkoord vóór hij wijzigingen aanbrengt die lastig terug te draaien zijn.
