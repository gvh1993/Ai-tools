<!--
Sjabloon voor .github/copilot-instructions.md (leesbaar voor Copilot, en voor Claude Code via een import in CLAUDE.md).
Vul alles met feiten uit JOUW repo. Verwijder wat niet van toepassing is. Verzin niets: markeer onzekere punten met TODO.
Schrijf concrete regels, geen algemeenheden: "Gebruik file-scoped namespaces" werkt, "schrijf clean code" niet.
Zet er vooral in wat een agent niet uit de code kan afleiden. Houd het kort (richtlijn: onder de 150 regels).
Geen geheimen, geen persoonsgegevens, geen klantnamen als de repo ooit publiek of gedeeld wordt.
-->

# <Projectnaam>

<Eén of twee zinnen: wat doet dit systeem, voor wie, en wat is de belangrijkste technische keuze.>

## Taal en stijl

- Code, identifiers en commitberichten: Engels. Overleg, documentatie en PR-teksten: Nederlands.
- <Specifieke stijlregels die niet in `.editorconfig` staan.>
- `.editorconfig` is leidend. <Welke regels zijn `error`?>

## Structuur

| Map / project | Verantwoordelijkheid |
| --- | --- |
| `<src/Project.Api>` | <bijv. HTTP-endpoints, geen businesslogica> |
| `<src/Project.Application>` | <bijv. use cases, validators> |
| `<src/Project.Domain>` | <bijv. entities en domeinlogica> |
| `<src/Project.Infrastructure>` | <bijv. EF Core, externe services> |
| `<tests/...>` | <welke testprojecten, welk soort tests> |

- Waar komt nieuwe code? <Beslisregels: "een nieuwe use case komt in X, een nieuwe entity in Y".>
- <Afhankelijkheidsregels, bijv. "Domain verwijst nooit naar Infrastructure".>

## Commando's

```
dotnet build <solution>.slnx
dotnet test <pad-naar-testproject>.csproj
dotnet test <solution>.slnx --filter "Category!=<excluded-category>"
dotnet format <solution>.slnx --verify-no-changes --no-restore --include <bestanden>
```

- <Bijzonderheden: benodigde services (database, Docker), omgevingsvariabelen (alleen de namen) en hoe je lokaal start.>
- <Is `dotnet format` over de hele solution niet schoon? Zeg dat, en dat alleen gewijzigde bestanden gecontroleerd worden.>

## Testen

- <Frameworks, bijv. xUnit en Reqnroll `.feature`-bestanden in het Nederlands.>
- <Naamgeving van tests en scenario's, bijv. ticketnummer in de scenarionaam.>
- <Waar testdata en fixtures staan en hoe ze geregistreerd worden (bijv. `CopyToOutputDirectory`).>
- Nieuw of gewijzigd gedrag krijgt tests. <Op welk niveau, en wanneer test-first?>

## Patronen en afspraken

- <Foutafhandeling: exceptions of resultaattypes?>
- <Validatie: waar, en waar komen foutteksten vandaan (resource-bestanden)?>
- <Logging: wat wel, wat nooit (persoonsgegevens, tokens).>
- <Autorisatie en privacy: hoe afgedwongen?>
- <Database: wijzigingen aan entities vragen een migratie, in welk project?>
- <API's: routes, naamgeving, registratie in een gateway, versiebeheer.>

## Valkuilen

<Dingen die vaak misgaan en niet uit de code blijken. Elke regel een concreet voorbeeld.>

- <bijv. "Route-namen moeten applicatiebreed uniek zijn; een dubbele naam blijkt pas bij het starten van de app.">
- <bijv. "Tests X en Y delen een database en mogen niet parallel draaien.">

## Git en werkwijze

- Branches: `feature/<id>` en `bugfix/<id>` vanaf `master`. Nooit rechtstreeks op `master`.
- Commitberichten: `<type>: <omschrijving> (#<id>)` met type `feat`, `fix`, `test` of `refactor`.
- PR's naar `master`, met `Related work items: #<id>` onderaan de beschrijving.
- Werk items via `/pickup` (taken en stories), `/pickup-bugfix` (bugs) en `/pr-followup` (reviewfeedback).

## Niet doen

- <bijv. "Geen nieuwe NuGet-pakketten toevoegen zonder overleg.">
- <bijv. "Geen wijzigingen in gegenereerde bestanden.">
- Geen geheimen, connectionstrings of persoonsgegevens in code, tests, logs of commits.
