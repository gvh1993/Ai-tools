# Templates

Sjablonen voor de instructiebestanden die agents in een repo lezen.

| Bestand | Gebruik |
| --- | --- |
| [`copilot-instructions.md`](copilot-instructions.md) | Kopieer naar `.github/copilot-instructions.md` in de doelrepo. Bevat de afspraken voor jouw codebase. De skills in deze repo verwijzen hiernaar. |
| [`CLAUDE.md`](CLAUDE.md) | Kopieer naar de root van de doelrepo. Importeert de instructies hierboven en voegt Claude Code-specifieke afspraken toe. |

Zo onderhoud je de inhoud op één plek, voor zowel Copilot als Claude Code.

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
- Is alles wat de skills (`pickup` e.a.) nodig hebben ingevuld: structuur, commando's, testafspraken en valkuilen?

Behandel het bestand als code: wijzig het in een PR en pas het aan zodra een agent twee keer dezelfde fout maakt.
