# Templates

Sjablonen voor de instructiebestanden die agents in een repo lezen.

| Bestand | Gebruik |
| --- | --- |
| [`copilot-instructions.md`](copilot-instructions.md) | Kopieer naar `.github/copilot-instructions.md` in de doelrepo. Bevat de afspraken voor jouw codebase. De skills in deze repo verwijzen hiernaar. |
| [`CLAUDE.md`](CLAUDE.md) | Kopieer naar de root van de doelrepo. Importeert de instructies hierboven en voegt Claude Code-specifieke afspraken toe. |

| [`vscode-mcp.json`](vscode-mcp.json) | Kopieer naar `.vscode/mcp.json` in de doelrepo. Start de Azure DevOps MCP-server `ado` (lokaal, via `npx`) met alleen de domeinen die de `ado-`skills nodig hebben. VS Code vraagt bij de start om de organisatienaam. |

Zo onderhoud je de inhoud op één plek, voor zowel Copilot als Claude Code.

## De Azure DevOps MCP-server

De `ado-`skills hebben de MCP-server `ado` nodig. De naam `ado` moet kloppen, want de skills verwijzen ernaar.

- **VS Code / Copilot:** gebruik `vscode-mcp.json` hierboven. De login loopt via de browser.
- **Claude Code:** `claude mcp add ado -- npx -y @azure-devops/mcp <organisatie> -d core work-items repositories`
- **`ado-pr-followup`** leest ook buildresultaten en heeft daarvoor het domein voor pipelines nodig. Voeg het toe aan de `-d`-lijst; controleer de exacte domeinnaam in de README van [microsoft/azure-devops-mcp](https://github.com/microsoft/azure-devops-mcp), want de lijst met domeinen kan veranderen. Zonder dat domein slaat de skill de checks over.
- Microsoft biedt ook een gehoste (remote) variant aan, waarvoor je niets lokaal installeert. Daar kies je domeinen niet via `-d`, dus controleer in de documentatie van de server of de tools die de skills gebruiken beschikbaar zijn.
- Kijk dat de toolnamen die de skills noemen (`wit_work_item`, `repo_pull_request_write`, ...) overeenkomen met wat jouw versie van de server aanbiedt.

## Invullen

Laat een agent de eerste versie maken, met feiten uit de code, en loop die zelf na. Een prompt die werkt:

```
Analyseer deze repo en vul templates/copilot-instructions.md in voor .github/copilot-instructions.md.
- Gebruik alleen feiten die je in de code, configuratie, pijplijnen en bestaande documentatie vindt.
- Verzin niets. Markeer wat je niet kunt vaststellen met TODO.
- Neem de echte build-, test- en formatcommando's op en controleer dat ze kloppen door ze te draaien.
- Beschrijf alleen wat een agent niet uit de code zelf kan afleiden. Geen algemeenheden.
- Hou het onder de 150 regels.
- Geen geheimen, geen persoonsgegevens.
```

## Kwaliteitscheck

Loop het resultaat na met deze vragen:

- Staat elke regel er omdat een agent het anders fout zou doen? Haal vage regels weg ("schrijf clean code").
- Kloppen de commando's? Draai ze.
- Staan de valkuilen erin die je collega's je ook zouden vertellen?
- Staat er niets in dat veroudert zonder dat iemand het merkt (aantallen, versies, namen van mensen)?
- Zijn er geen geheimen, persoonsgegevens of klantnamen opgenomen?
- Is alles wat de skills (`ado-pickup` e.a.) nodig hebben ingevuld: structuur, commando's, testafspraken en valkuilen?

Behandel het bestand als code: wijzig het in een PR en pas het aan zodra een agent twee keer dezelfde fout maakt.
