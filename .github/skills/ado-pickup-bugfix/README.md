# Skill: ado-pickup-bugfix

Pakt een Azure DevOps Bug op, met de oorzaak en een reproductietest als uitgangspunt. Het is de bug-variant van [`ado-pickup`](../ado-pickup/README.md) en gebruikt dezelfde checkpoints en veiligheidsregels.

```
/ado-pickup-bugfix 12345
```

## Verschil met pickup

| | `ado-pickup` | `ado-pickup-bugfix` |
| --- | --- | --- |
| Fase 1 | Vereisten, vragen, plan | Oorzaak-hypothese met bewijs (`git blame`/`log`), vragen over repro en impact, plan |
| Begin van fase 2 | Slices implementeren | **Eerst een falende test** die de bug reproduceert, bevestigd om de goede reden |
| Fix | Naar plan | Minimale wijziging op de oorzaak, geen workaround voor het symptoom |
| Vergelijkbare fouten | n.v.t. | Alleen melden, niet meefixen zonder akkoord |
| Backport | n.v.t. | Wordt gemeld, nooit zelf uitgevoerd |
| Bewijs in het eindrapport | Verificatie | Reproductietest faalde vóór en slaagt na de fix |

## Werkwijze

**Fase 1 (alleen lezen)**: bug en context ophalen, het pad van het symptoom door de code volgen, oorzaak-hypothese opstellen, grillen, plan en groottecheck. Daarna **checkpoint 1**.

**Fase 2 (na akkoord)**: voorcontroles, branch `bugfix/<id>`, baseline, bug claimen (Active), reproductietest schrijven en laten falen, fix, verifiëren, self-review, PR-beschrijving. Daarna **checkpoint 2**: de PR wordt alleen op jouw verzoek aangemaakt, waarna het item op On Hold met tag `PR` gaat.

Kan de agent de bug niet reproduceren, dan stopt hij en vraagt om meer informatie in plaats van een gok te committen.

## Vereisten

Zelfde als bij `ado-pickup`: de MCP-server `ado` met de domeinen `core`, `work-items` en `repositories`, een .NET-solution en bij voorkeur `.github/copilot-instructions.md` en `docs/definition-of-done.md`. Vul dezelfde plaatshouders in (`<ado-project>`, `<solution>`, `<excluded-category>`) en controleer de toolnamen tegen jouw MCP-versie.

## Tips

- Een goede Bug heeft repro-stappen, verwacht en werkelijk gedrag en de versie. Ontbreekt dat, dan krijg je dat als eerste open vraag terug. Dat is bedoeld.
- Test op het laagste niveau waarop de bug reproduceerbaar is. Een unit test is sneller en stabieler dan een scenario.
- Gebruik verzonnen testdata, ook als het ticket echte gegevens bevat.
