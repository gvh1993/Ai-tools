# Skill: characterize-migrate

Migreert of herstructureert bestaande code veilig: eerst vastleggen wat de code nu doet, dan pas verplaatsen. Bedoeld voor moderniseringswerk, zoals het opdelen van een monoliet, het introduceren van modules of aggregates, of het losknippen van koppelingen.

```
/characterize-migrate src/Orders naar een eigen module
/characterize-migrate Billing DDD-aggregate
```

Dit is een skill zonder platformprefix: hij gebruikt geen tools van een ticketsysteem of een repo-host en werkt dus overal waar je code hebt.

## Werkwijze

**Fase 1 (alleen lezen)**
1. Het onderdeel afbakenen en de ingangen en uitgangen in kaart brengen.
2. Koppelingen en naden zoeken, zoals statische toestand, `DateTime.Now`, directe database-toegang en gedeelde entities.
3. Een gedragsinventaris maken van wat behouden moet blijven, met bron en bestaande tests.
4. Het doelmodel en een sliceplan opstellen.
5. **Checkpoint 1**: stopt en wacht op expliciet akkoord.

**Fase 2 (na akkoord)**
1. Voorcontroles, branch en baseline van build en tests.
2. Per slice: karakteriseringstests schrijven, bewijzen dat ze op de onveranderde code slagen en iets afdekken, committen. Dan naden openen en in kleine stappen verplaatsen, met na elke stap groene tests.
3. Verifiëren, self-review en een PR-beschrijving als tekst.

## Wat de skill bewust niet doet

- **Geen gedragsverandering.** Gedrag dat fout lijkt, wordt vastgelegd en gemeld, niet verholpen. Zo blijft een refactoring reviewbaar en terug te draaien.
- **Geen tests aanpassen tijdens het verplaatsen**, behalve mechanisch (namespace, using, bestandslocatie). Een omgezette assertie betekent dat het gedrag verandert, en dan stopt de skill.
- **Geen wijzigingen aan publieke contracten** (API's, berichten, gedeelde schema's) zonder dat jij dat bij het plan hebt besloten. Schemawijzigingen gaan in aparte stappen.
- **Niets pushen of mergen** zonder dat je erom vraagt.

## Vereisten

Een .NET-solution met build en tests, en bij voorkeur een `.github/copilot-instructions.md` waarin het doelpatroon staat. Vul de plaatshouders `<solution>` en `<excluded-category>` in. Voor andere stacks pas je de commando's aan.

## Tips

- Begin met één klein, laag-risico onderdeel om de aanpak en de tests te leren kennen voor je een groot deel aanpakt.
- Is het onderdeel nauwelijks getest, reken dan op veel werk in de karakteriseringsfase. Dat is het deel dat de migratie veilig maakt.
- Plan reviewmomenten per slice. Kleine PR's met alleen verplaatsingen zijn veel makkelijker te beoordelen dan één grote.
