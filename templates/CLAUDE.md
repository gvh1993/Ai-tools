<!--
Sjabloon voor CLAUDE.md in de root van een repo (Claude Code leest dit bestand automatisch bij de start van een sessie).
De inhoud staat in .github/copilot-instructions.md, zodat Copilot en Claude Code dezelfde afspraken volgen en je niets dubbel onderhoudt.
Hier komt alleen wat specifiek is voor Claude Code. Houd dit bestand kort.
-->

@.github/copilot-instructions.md

## Werkwijze met Claude Code

- Begin elke niet-triviale taak in plan mode: eerst verkennen en een plan voorleggen, pas na akkoord wijzigen.
- Geef jezelf een controleerbaar doel (build groen, specifieke test slaagt) en verifieer dat voordat je klaar meldt.
- Lees bestaande code en patronen voordat je nieuwe schrijft. Volg wat er staat.
- Houd wijzigingen klein en binnen de scope van de taak. Meld wat je onderweg tegenkomt in plaats van het mee te nemen.
- Stel een vraag als iets onduidelijk is, in plaats van te gokken.

## Skills

De skills (`ado-pickup`, `ado-pickup-bugfix`, `ado-pr-followup`, `ado-review`, `ado-refine`, `characterize-migrate` en `adr`) staan in `.claude/skills/` (Claude Code) en/of `.github/skills/` (Copilot). Gebruik ze alleen als de gebruiker ze expliciet aanroept.

## Persoonlijke voorkeuren

Zet persoonlijke afspraken in `CLAUDE.local.md` (niet committen) of in `~/.claude/CLAUDE.md`, niet hier.
