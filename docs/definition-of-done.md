# Definition of Done

Checklist voor de skills `/ado-pickup`, `/ado-pickup-bugfix` en `/ado-pr-followup` ([.github/skills](../.github/skills)). Alleen punten die uit de repo volgen zijn ingevuld; de rest is `TODO: aanvullen door team`. Pas deze lijst aan op jouw team en repo.

## Afgeleid uit de repo

### Build en tests
- [ ] `dotnet build <solution>.slnx` slaagt zonder errors (de pipeline bouwt met `--configuration Release`).
- [ ] Geen nieuwe test-failures ten opzichte van de baseline aan het begin van de branch.
- [ ] Nieuw of gewijzigd gedrag heeft tests (xUnit, gedrag via Reqnroll `.feature`-bestanden in het Nederlands).
- [ ] Reqnroll-scenario's hebben een ticketnummer in de naam (bijv. `12345 | Scenario-01`).
- [ ] Nieuwe testfixtures onder `TestFiles` zijn in de `.csproj` geregistreerd met `CopyToOutputDirectory`.
- [ ] `dotnet test <solution>.slnx --filter "Category!=<excluded-category>"` is groen.

### Codekwaliteit
- [ ] `dotnet format <solution>.slnx --verify-no-changes --no-restore --include <gewijzigde bestanden>` is schoon. (De hele solution is dat nu niet; zie TODO.)
- [ ] Geen nieuwe analyzer-warnings in gewijzigde code. `TreatWarningsAsErrors` staat niet aan, dus dit is een afspraak en geen afdwinging.
- [ ] `.editorconfig` wordt gevolgd (o.a. accolades verplicht, file-scoped namespaces, beide `error`).
- [ ] Foutteksten van validators komen uit de resource-bestanden.
- [ ] Geen geheimen, connectionstrings of persoonsgegevens in code, tests, commits of PR.
- [ ] Geen wijzigingen buiten de scope van de work items.

### Afhankelijk van de wijziging
- [ ] Wijziging aan entities of `DbContext`: EF Core-migratie aanwezig in het project van die `DbContext`.
- [ ] Nieuwe of gewijzigde route in de WebApi: ook geregistreerd in de API-gateway-definitie van de repo (`externalAvailable` bewust gekozen).
- [ ] Route-namen (`Name = nameof(...)`) zijn applicatiebreed uniek (conflict blijkt pas bij het starten van de app of in tests).

### Bugfixes
- [ ] Er is een regressietest die vóór de fix faalde (om de goede reden) en erna slaagt.
- [ ] De fix lost de oorzaak op, niet alleen het symptoom, en blijft binnen de scope.
- [ ] Vergelijkbare plekken en een eventuele backport naar een release-branch zijn gemeld.

### Pull request
- [ ] Doelbranch is `master`; de branch heet `feature/<id>` of `bugfix/<id>`.
- [ ] Er is niet al een andere actieve PR voor dezelfde branch.
- [ ] PR-beschrijving noemt het work item (`Related work items: #<id>`).
- [ ] PR-pipeline is groen: build, tests, kwaliteitsgate, code scanning en dependency scanning.

## TODO: aanvullen door team

- TODO: aanvullen door team: aantal en soort reviewers.
- TODO: aanvullen door team: minimale testdekking (de pipeline publiceert coverage, maar er is geen drempel in de repo).
- TODO: aanvullen door team: omgaan met de bestaande format- en analyzer-schuld (`dotnet format` over de hele solution is niet schoon); wel of niet `TreatWarningsAsErrors`.
- TODO: aanvullen door team: acceptatie door PO en acceptatiecriteria afvinken.
- TODO: aanvullen door team: documentatie (API-documentatie, Swagger-beschrijvingen) en release notes.
- TODO: aanvullen door team: deploy naar testomgeving en handmatige test.
- TODO: aanvullen door team: security- en privacycheck (AVG) bij wijzigingen aan persoonsgegevens.
- TODO: aanvullen door team: wie zet het work item op welke State, en wanneer.
