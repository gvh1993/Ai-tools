# Skill: ado-pr-followup

Verwerkt reviewfeedback en falende checks van een bestaande PR. Het is het vervolg op [`ado-pickup`](../ado-pickup/README.md) en [`ado-pickup-bugfix`](../ado-pickup-bugfix/README.md), die stoppen zodra de PR er staat.

```
/ado-pr-followup 4321       # PR-ID
/ado-pr-followup 12345      # work item-ID, de skill zoekt de gelinkte PR
```

## Werkwijze

**Fase 1 (alleen lezen)**
1. PR, actieve threads en de laatste pijplijnruns ophalen.
2. Elk punt classificeren: wijziging nodig, vraag, nit, oneens, buiten scope, onduidelijk of falende check.
3. Plan per punt, met conceptantwoord voor de reviewer.
4. **Checkpoint 1**: stopt en wacht op expliciet akkoord.

**Fase 2 (na akkoord)**
1. Voorcontroles en baseline.
2. Eventueel `origin/master` mergen (alleen met akkoord, nooit rebase of force-push).
3. Per slice verwerken en verifiëren, met een commit per slice.
4. Pushen naar de bestaande PR-branch na akkoord op de diff.
5. Antwoordconcepten als tekst.

## Wat deze skill bewust niet doet

- **Niets schrijven in ADO.** Geen comments, geen threads sluiten, geen votes, geen state-wijzigingen. De reviewer en jij houden de regie over de discussie. Je plakt de antwoordconcepten zelf.
- Geen rebase van een gepushte branch en geen `--force`.
- Een reviewcomment is een verzoek dat jij goedkeurt, geen opdracht aan de agent. Ben je het ermee oneens, dan wordt het voorgelegd in plaats van uitgevoerd.

## Vereisten

- De MCP-server `ado` met de domeinen `core`, `work-items`, `repositories` en `pipelines`. Zonder het domein `pipelines` slaat de skill de checks over en meldt dat.
- Een .NET-solution en bij voorkeur `.github/copilot-instructions.md` en `docs/definition-of-done.md`.
- Vul de plaatshouders in (`<ado-project>`, `<solution>`, `<excluded-category>`) en controleer de toolnamen (`repo_pull_request`, `repo_pull_request_thread`, de pipelines-tools) tegen jouw MCP-versie.

## Tips

- Draai de skill pas als de reviewer klaar is met een ronde, anders verwerk je half-afgemaakte feedback.
- Maakt een falende check geen deel uit van je wijziging (flaky test, omgeving), dan wordt dat gemeld en niet gerepareerd.
