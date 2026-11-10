# Definition of Done

Checklist voor `/pickup` ([.github/skills/pickup/SKILL.md](../.github/skills/pickup/SKILL.md)). Alleen punten die uit de repo volgen zijn ingevuld; de rest is `TODO: aanvullen door team`.

## Afgeleid uit de repo

### Build en tests
- [ ] `dotnet build [INSERT HERE].slnx` slaagt zonder errors (de pipeline bouwt met `--configuration Release`).
- [ ] Nieuw of gewijzigd gedrag heeft tests (xUnit, gedrag via Reqnroll `.feature`-bestanden in het Nederlands).
- [ ] Reqnroll-scenario's hebben een ticketnummer in de naam (bijv. `87616 | ToetsB-Val-01`).
- [ ] Nieuwe testfixtures onder `TestFiles` zijn in de `.csproj` geregistreerd met `CopyToOutputDirectory`.
- [ ] `dotnet test [INSERT HERE].slnx --filter "Category!=AgentDisabled"` is groen.

### Codekwaliteit
- [ ] `dotnet format [INSERT HERE].slnx --verify-no-changes --no-restore --include <gewijzigde bestanden>` is schoon. (De hele solution is dat nu niet; zie TODO.)
- [ ] Geen nieuwe analyzer-warnings in gewijzigde code (`Meziantou.Analyzer`, Visual Studio Threading Analyzers, .NET/ASP.NET-analyzers). `TreatWarningsAsErrors` staat niet aan, dus dit is een afspraak en geen afdwinging.
- [ ] `.editorconfig` wordt gevolgd (o.a. accolades verplicht, file-scoped namespaces, beide `error`).
- [ ] Foutteksten van validators komen uit de resource-bestanden (`ValidationErrors`, `Resources`).
- [ ] Geen geheimen, connectionstrings of persoonsgegevens in code, tests, commits of PR.

### Afhankelijk van de wijziging
- [ ] Wijziging aan entities of `DbContext`: EF Core-migratie aanwezig (`Shared.Database`, `Shared.Report.Database` of `Portal.Auth.Database`).
- [ ] Nieuwe of gewijzigde route in `[INSERT HERE].WebApi`: ook geregistreerd in `src/[INSERT HERE]/pipelines/infrastructure/apim/apim.bicep` (`externalAvailable` bewust gekozen).
- [ ] Route-namen (`Name = nameof(...)`) zijn applicatiebreed uniek (conflict blijkt pas bij het starten van de app of in tests).

### Pull request
- [ ] Doelbranch is `master`; de branch heet `feature/<id>` of `bugfix/<id>`.
- [ ] PR-beschrijving noemt het work item (`Related work items: #<id>`).
- [ ] PR-pipeline is groen: build, tests, SonarQube quality gate, CodeQL en dependency scanning.

## TODO: aanvullen door team

- TODO: aanvullen door team: aantal en soort reviewers.
- TODO: aanvullen door team: minimale testdekking (de pipeline publiceert coverage, maar er is geen drempel in de repo).
- TODO: aanvullen door team: omgaan met de bestaande format- en analyzer-schuld (`dotnet format` over de hele solution is niet schoon); wel of niet `TreatWarningsAsErrors`.
- TODO: aanvullen door team: acceptatie door PO en acceptatiecriteria afvinken.
- TODO: aanvullen door team: documentatie (`documentation/` van API en Auth, Swagger-beschrijvingen) en release notes.
- TODO: aanvullen door team: deploy naar testomgeving en handmatige test.
- TODO: aanvullen door team: security- en privacycheck (AVG) bij wijzigingen aan persoonsgegevens.
- TODO: aanvullen door team: wie zet het work item op welke State, en wanneer.