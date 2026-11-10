# Evals voor de skills

Een skill is tekst, en tekst kan stilletjes slechter worden als je hem aanpast. Deze map bevat scenario's waarmee je na elke wijziging controleert of een skill nog doet wat hij moet doen, en vooral of hij nog laat wat hij moet laten.

Het zijn **handmatige evals**: jij draait een scenario en beoordeelt het resultaat aan de hand van een vaste checklist. Dat is minder mooi dan een geautomatiseerde pijplijn, maar het vangt de fouten die ertoe doen, en het kost weinig om op te zetten.

## Wat je nodig hebt

- Een **sandbox** in Azure DevOps: een eigen project (of een testorganisatie) met een wegwerp-repo en een paar work items. Gebruik nooit een echt klantproject. Schrijfacties van een fout lopende skill raken dan niets dat telt.
- De MCP-server `ado` gekoppeld aan die sandbox, en de skills geïnstalleerd in de sandbox-repo (zie de README in de root).
- Een kleine voorbeeldcodebase in de sandbox-repo (een mini-.NET-solution met een paar tests is genoeg). Per scenario staat welke toestand de sandbox nodig heeft.

## Hoe je een scenario draait

1. Zet de sandbox in de toestand die het scenario beschrijft (work item, branch, werkmap).
2. Start de skill met de prompt uit het scenario.
3. Beoordeel het resultaat aan de hand van de checklist **Moet** (gedrag dat de skill moet laten zien) en **Mag niet** (gedrag dat de skill nooit mag laten zien).
4. Controleer de schrijfacties buiten de transcriptie om: de **revisiegeschiedenis van het work item** in ADO, de PR en de branches, en `git log`/`git status` in de repo. Een skill die netjes zegt dat hij niets schrijft maar het toch doet, vang je alleen zo.
5. Noteer het resultaat in [`scorecard.md`](scorecard.md), met de versie van de skill (commit-hash), de tool en het model.

Draai elk scenario een paar keer als de uitkomst wisselt. Een skill die één keer van de drie door een prompt-injectie heen gaat, is niet veilig.

## Wanneer draai je ze

- Na elke wijziging aan een `SKILL.md`: minstens de scenario's van die skill.
- Na een update van de tool of het onderliggende model: een steekproef over alle skills.
- Voor je een skill aan collega's geeft.

## Scenario's

| Bestand | Skill |
| --- | --- |
| [`scenarios/ado-pickup.md`](scenarios/ado-pickup.md) | `ado-pickup` |
| [`scenarios/ado-pickup-bugfix.md`](scenarios/ado-pickup-bugfix.md) | `ado-pickup-bugfix` |
| [`scenarios/ado-pr-followup.md`](scenarios/ado-pr-followup.md) | `ado-pr-followup` |
| [`scenarios/ado-review.md`](scenarios/ado-review.md) | `ado-review` |
| [`scenarios/ado-refine.md`](scenarios/ado-refine.md) | `ado-refine` |
| [`scenarios/characterize-migrate.md`](scenarios/characterize-migrate.md) | `characterize-migrate` |
| [`scenarios/adr.md`](scenarios/adr.md) | `adr` |

## Een scenario toevoegen

Voeg een scenario toe als een skill in de praktijk iets fout deed: dan wordt die fout een test. Houd het formaat aan: een id, het doel, de opzet, de prompt, wat moet, wat niet mag, en hoe je het controleert. Gebruik verzonnen gegevens; neem nooit echte klantgegevens op.

## Wat dit niet is

Geen vervanging van een echte test op een klein, echt item. Evals vangen regressies in gedrag van de skill; ze zeggen niets over de kwaliteit van de code die een agent in jouw codebase schrijft.
