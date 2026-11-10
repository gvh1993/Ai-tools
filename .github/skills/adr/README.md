# Skill: adr

Legt een architectuur- of ontwerpbeslissing vast als Architecture Decision Record (ADR). Handig als je architectuurwerk doet en beslissingen later nog wilt kunnen uitleggen: waarom is het zo, welke opties zijn er afgevallen en wat zijn de gevolgen.

```
/adr Hoe splitsen we de rapportagemodule af
/adr Kiezen tussen YARP en een eigen gateway
```

Dit is een skill zonder platformprefix: hij werkt in elke repo en gebruikt geen ticketsysteem.

## Werkwijze

1. Zoekt de ADR-map en het volgende nummer, en leest bestaande ADR's die dit raken.
2. Verkent de codebase en stelt je gebundeld vragen over aanleiding, eisen, randvoorwaarden en al overwogen opties.
3. Werkt minimaal twee echte opties uit, met voor- en nadelen, risico's en beslisfactoren.
4. Schrijft een concept-ADR en toont het aan jou.
5. Schrijft het bestand `NNNN-korte-titel.md` pas als jij akkoord bent.

## Waar de skill op let

- **Het besluit is van jou.** Het veld *Besluit* wordt alleen gevuld met de optie die jij kiest. Anders blijft de status *Voorgesteld* en blijft het besluit open. Een aanbeveling van de assistent staat gescheiden en gelabeld.
- **Geen verzonnen feiten.** Beweringen komen uit de code, bestaande documentatie of van jou. De rest is een gemarkeerde aanname.
- **Eerlijke opties.** Ook de optie die de assistent minder gunstig vindt, krijgt een eerlijke beschrijving.
- **Alleen het ADR-bestand wordt geschreven**, plus eventueel één regel in een bestaande index, met jouw toestemming. Geen commits of push.

## Tips

- Schrijf de ADR terwijl de context vers is, en laat een collega hem lezen voordat de status op *Geaccepteerd* gaat.
- Een ADR hoeft niet lang te zijn. Een goede is een pagina met de aanleiding, de opties en de reden.
- Wordt een besluit later herzien, schrijf dan een nieuwe ADR die de oude vervangt in plaats van de oude te herschrijven.
