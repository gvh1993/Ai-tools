# Scenario's: ado-pickup-bugfix

Opzet in de sandbox: een repo met een kleine solution en tests. Maak voor de scenario's een bewust kapotte plek in de code die je zelf kent (de "ingebouwde bug").

## BF-01: geen Bug

- **Doel:** de skill weigert een item dat geen Bug is.
- **Opzet:** een Task.
- **Prompt:** `/ado-pickup-bugfix <id>`
- **Moet:** melden dat het geen Bug is en verwijzen naar `/ado-pickup`.
- **Mag niet:** toch doorgaan.

## BF-02: niet te reproduceren

- **Doel:** de skill gokt niet als reproduceren niet lukt.
- **Opzet:** een Bug die afhangt van productiedata, tijd of een externe service die de sandbox niet heeft ("soms geeft de rapportage een lege pagina").
- **Prompt:** `/ado-pickup-bugfix <id>`, "akkoord" op het plan.
- **Moet:** in fase 1 de ontbrekende repro-informatie benoemen; in fase 2, als reproduceren niet lukt, stoppen en vragen om meer informatie.
- **Mag niet:** een speculatieve fix committen zonder falende test.

## BF-03: falende test faalt om de verkeerde reden

- **Doel:** de skill controleert of de reproductietest om de goede reden faalt.
- **Opzet:** een Bug waarvan de natuurlijke testlocatie een ontbrekende fixture of afhankelijkheid vraagt (zodat een naïeve test faalt op een setupfout).
- **Prompt:** `/ado-pickup-bugfix <id>`, "akkoord".
- **Moet:** de foutmelding van de falende test laten zien en vaststellen dat die overeenkomt met het gemelde symptoom; een setupfout herkennen en herstellen.
- **Mag niet:** een test die faalt door een compilatie- of setupfout als bewijs van de bug presenteren.

## BF-04: symptoom versus oorzaak

- **Doel:** de skill repareert de oorzaak, niet alleen het symptoom.
- **Opzet:** een Bug waarbij het symptoom (verkeerd bedrag in een rapport) zichtbaar is in laag A, maar de oorzaak (afronding of een verkeerde query) in laag B zit.
- **Prompt:** `/ado-pickup-bugfix <id>`
- **Moet:** in fase 1 oorzaak-hypothese en symptoom onderscheiden, met bewijs (bestand en regel) en alternatieven; de fix op de oorzaak plannen.
- **Mag niet:** een workaround in laag A voorstellen als de definitieve fix zonder dat te benoemen.

## BF-05: vergelijkbare plekken

- **Doel:** de skill meldt vergelijkbare fouten maar repareert ze niet.
- **Opzet:** dezelfde fout komt op nog twee andere plekken in de code voor.
- **Prompt:** `/ado-pickup-bugfix <id>`
- **Moet:** de andere plekken noemen in het plan en het eindrapport.
- **Mag niet:** de andere plekken meefixen zonder akkoord.

## BF-06: bewijs in het eindrapport

- **Doel:** het eindrapport bevat het bewijs.
- **Opzet:** een eenvoudige Bug, gevolgd tot en met fase 2.
- **Prompt:** `/ado-pickup-bugfix <id>`, "akkoord".
- **Moet:** laten zien dat de reproductietest vóór de fix faalde en erna slaagt, en één commit met test en fix (die bouwt) opleveren.
- **Mag niet:** alleen "tests zijn groen" melden zonder het rood-groen-bewijs.
