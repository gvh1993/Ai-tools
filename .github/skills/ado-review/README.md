# Skill: ado-review

Beoordeelt een Azure DevOps pull request alleen-lezen en levert een reviewrapport als tekst. Handig voor je eigen PR vóór je reviewers toevoegt, en als eerste lezing van de PR van een collega.

```
/ado-review 4321
```

## Wat je krijgt

Een rapport met een samenvatting, een advies (*klaar*, *klaar na kleine aanpassingen* of *eerst bespreken*), bevindingen per ernst (blokkerend, belangrijk, suggestie, nit, vraag), een toets tegen de Definition of Done en een lijst van wat niet is beoordeeld. Op verzoek krijg je ook kant-en-klare commentaarteksten.

## Wat de skill bewust niet doet

- **Niets schrijven.** Geen comments, votes, goedkeuring of PR-status in ADO. Geen bestanden of branches lokaal wijzigen.
- **Niet beslissen.** Het advies is voor de menselijke reviewer. Een rapport zonder bevindingen is geen garantie dat de PR goed is.
- **De werkmap met rust laten.** De diff komt uit `git fetch` en `git diff` tussen remote-referenties, dus je hoeft niet van branch te wisselen.

## Vereisten

De MCP-server `ado` met de domeinen `core`, `work-items` en `repositories`, en een checkout van de repo waarin de PR staat. Bij voorkeur ook een gevulde `.github/copilot-instructions.md` en `docs/definition-of-done.md`: de review is zo goed als de afspraken waartegen getoetst wordt. Vul de plaatshouder `<ado-project>` in en controleer de toolnamen tegen jouw MCP-versie.

## Tips

- Combineer met [`ado-pr-followup`](../ado-pr-followup/README.md): `ado-review` voor het zoeken naar problemen vóór de PR open staat, `ado-pr-followup` voor het verwerken van de feedback erna.
- Stuur je klantcode naar een model, doe dat dan alleen met de tooling en het akkoord waar je opdrachtgever mee instemt.
