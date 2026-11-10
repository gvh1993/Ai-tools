# Skill: ado-refine

Verfijnt Azure DevOps work items vóór de sprint. Het is de grill-stap van [`ado-pickup`](../ado-pickup/README.md), maar eerder in het proces: zodat een item al helder is op het moment dat iemand het oppakt.

```
/ado-refine 12345
/ado-refine 12345 12346
```

## Wat je krijgt

Een rapport als tekst met:

1. een samenvatting en een oordeel per item (*klaar*, *bijna klaar*, *niet klaar*);
2. vragen voor de PO en voor de ontwikkelaar, elk met een voorgestelde aanname;
3. voorgestelde acceptatiecriteria als Gherkin in het Nederlands (voor Reqnroll);
4. de impact op de codebase (projecten, endpoints, entities, migraties, tests);
5. een splitsingsvoorstel en een grove omvangsindicatie bij grote items;
6. risico's en eventuele spikes;
7. een Definition of Ready-check.

## Wat de skill bewust niet doet

- **Niets schrijven in ADO.** Geen velden, comments of nieuwe items. Wat je overneemt, plaats je zelf.
- **Niets verzinnen.** Wat niet in het item, de parent of de code staat, is een aanname of een vraag, en wordt zo gemarkeerd.
- **Niet schatten in uren of punten.** Hooguit een grove indicatie met de onzekerheid erbij; schatten blijft iets van het team.

## Vereisten

De MCP-server `ado` met de domeinen `core`, `work-items` en `repositories`, en een checkout van de repo waar de wijziging plaatsvindt. Vul de plaatshouder `<ado-project>` in en controleer de toolnamen tegen jouw MCP-versie. De Definition of Ready staat in de skill zelf; pas die aan op wat jouw team afspreekt.

## Tips

- Draai de skill vóór de refinement en loop de vragenlijst met de PO door. Zo gaat de tijd in de sessie naar beslissingen in plaats van naar uitzoeken.
- Is een item `niet klaar`, gebruik dan het vragenlijstje als agenda in plaats van het gewoon in de sprint te laten vallen.
- Combineer met [`ado-pickup`](../ado-pickup/README.md): als de vragen zijn beantwoord, is de grill-stap daar sneller.
