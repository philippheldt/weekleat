# weekleat – Web-App

Wochenplaner für iOS **und** Android: Aus euren Lieblingsrezepten (`public/rezepte.yaml`) wird per Knopfdruck ein Wochenplan inklusive Einkaufsliste erstellt. Wochenplan, Bewertungen, Einstellungen und Einkaufsliste werden live zwischen euren Handys synchronisiert.

## Was die App kann

- **Rezepte generieren**: plant alle aktiven, nicht festgehaltenen Tage neu.
  - Häufigkeit pro Kategorie (Nudeln, Reis, Kartoffeln, Gebackenes, Sonstiges): nie / selten / mittel / häufig
  - Ernährung: alles / vegetarisch / vegan, dazu „Fleisch & Fisch“: nie / selten (1×) / mittel (2×) / häufig (4×) pro Woche
  - **Upvotes/Downvotes**: jedes 👍 macht ein Rezept ca. 30 % wahrscheinlicher, jedes 👎 entsprechend seltener
  - **Abwechslung**: Rezepte der letzten N Wochen werden übersprungen
  - gleiche Kategorien an aufeinanderfolgenden Tagen werden vermieden
  - `nur_an: [fr, sa, so]` im Rezept beschränkt es auf bestimmte Tage
- **Einzelnen Tag neu würfeln**: Karte nach links wischen (wie in der iOS-App) oder im Tag auf „Neu würfeln“ tippen.
- **Rezepte fest einplanen**: im Tag „Festhalten“ oder „Anderes Rezept wählen“, oder in der Rezeptsammlung „Fest einplanen am …“.
- **Einkaufsliste**: Zutaten der Woche, auf eure Portionen umgerechnet und zusammengefasst. Vorratszutaten (Salz, Pfeffer …) werden weggelassen. **Eigene Einträge** (Milch, Klopapier …) bleiben erhalten, wenn neu generiert wird.
- Funktioniert offline und lässt sich auf den Homescreen legen.

## Einrichtung (einmalig, ca. 15 Minuten)

### 1. Supabase (kostenlose Datenbank für den Abgleich)

1. Auf [supabase.com](https://supabase.com) ein kostenloses Projekt anlegen.
2. Im Dashboard **SQL Editor** öffnen, den Inhalt von [`supabase/schema.sql`](supabase/schema.sql) einfügen und ausführen.
3. **Authentication → Users → Add user**: einen gemeinsamen Haushalts-Login anlegen (E-Mail + Passwort, „Auto Confirm User“ anhaken).
4. **Authentication → Sign In / Providers**: „Allow new users to sign up“ **ausschalten**, damit sich niemand Fremdes registrieren kann.
5. **Project Settings → API**: „Project URL“ und den „anon public“-Key notieren. Der Key ist öffentlich gedacht – geschützt wird über den Login.

### 2. Veröffentlichen mit GitHub Pages

1. Im Repo unter **Settings → Secrets and variables → Actions → Variables** zwei Variablen anlegen:
   - `VITE_SUPABASE_URL` = Project URL
   - `VITE_SUPABASE_ANON_KEY` = anon public Key
2. **Settings → Pages → Source: „GitHub Actions“** wählen.
3. Auf `main` pushen (oder den Workflow „Web-App“ manuell starten). Die App ist dann unter `https://<user>.github.io/weekleat/` erreichbar.

> GitHub Pages ist bei privaten Repos nur mit bezahltem GitHub-Plan verfügbar. Alternative: Repo bei [Netlify](https://netlify.com) oder [Vercel](https://vercel.com) verbinden (Base directory `web`, Build `npm run build`, Output `dist`, die beiden Variablen dort als Environment Variables eintragen).

### 3. Auf die Handys

- **iPhone (Safari)**: Seite öffnen → Teilen → „Zum Home-Bildschirm“
- **Android (Chrome)**: Seite öffnen → ⋮ → „Zum Startbildschirm hinzufügen“ / „App installieren“

Dann auf beiden Handys mit dem Haushalts-Login anmelden – fertig.

## Rezepte pflegen

Alle Rezepte stehen in [`public/rezepte.yaml`](public/rezepte.yaml); das Format ist oben in der Datei erklärt. Bearbeiten geht auch am Handy direkt auf github.com (Stift-Symbol) – in der App führt der Button „rezepte.yaml bearbeiten“ in der Rezeptsammlung direkt dorthin. Nach dem Speichern baut GitHub die App neu, nach ca. 1–2 Minuten sind die Änderungen da.

Fehler in der Datei (z. B. fehlender Titel, unbekannte Kategorie) werden in der Rezeptsammlung oben als Hinweis angezeigt.

> Tipp: Wenn ihr ein Rezept umbenennt, bekommt es eine neue `id` und verliert seine Bewertungen. Mit `id: alter-name` bleibt alles erhalten.

## Entwicklung

```bash
cd web
npm install
npm run dev     # http://localhost:5173 – ohne .env.local läuft alles lokal im Browser
npm test        # Tests für Zutaten, Katalog, Generator, Einkaufsliste
npm run build
```

Ohne Supabase-Variablen speichert die App alles im Browser (praktisch zum Ausprobieren, aber ohne Abgleich).

Aufbau:

| Datei | Inhalt |
|---|---|
| `src/lib/catalog.js` | liest und prüft `rezepte.yaml` |
| `src/lib/ingredients.js` | versteht Zutaten („375g Kartoffeln“), rechnet um und fasst zusammen |
| `src/lib/generator.js` | Wochenplan-Generator (Gewichtung, Votes, Abwechslung, Fleischtage) |
| `src/lib/shopping.js` | Einkaufsliste aus dem Plan |
| `src/lib/store.js` | Speicher + Live-Sync über Supabase (eine Tabelle `items`) |
| `src/ui/*` | Oberfläche |
| `scripts/convert_assets.py` | hat die Illustrationen aus der iOS-App übernommen |
