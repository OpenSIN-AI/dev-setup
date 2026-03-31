# GitHub-Collaboration-README

Diese Anleitung beschreibt, wie wir auf GitHub sauber zusammenarbeiten:

- mit **Issues**
- mit **Branches**
- mit **Pull Requests**
- mit **Reviews**
- mit **klarem Übergang zwischen Planung und Umsetzung**

## Grundprinzip

Gute Zusammenarbeit auf GitHub folgt einem einfachen Ablauf:

1. Problem oder Aufgabe wird sichtbar
2. Das Thema wird als **Issue** festgehalten
3. Es wird in **GitHub Projects** priorisiert
4. Die Umsetzung läuft auf einem **Branch**
5. Änderungen kommen als **Pull Request** ins Review
6. Nach Merge ist der Stand nachvollziehbar abgeschlossen

Kurz:

> Nicht direkt im Code anfangen. Erst sichtbar machen, dann umsetzen.

---

## 1. Issues richtig nutzen

Ein Issue ist die kleinste saubere Einheit für verfolgte Arbeit.

Nutze Issues für:

- Bugs
- Features
- Verbesserungen
- Doku-Aufgaben
- operative Aufgaben

### Ein gutes Issue enthält

- klaren Titel
- Kontext
- Ziel
- Akzeptanzkriterien oder Definition of Done
- falls nötig Screenshots, Links oder Beispiele

### Gute Titel

- `Fix broken navigation on mobile menu`
- `Add setup guide for GitHub Discussions`
- `Document repository onboarding flow`

### Schlechte Titel

- `Bug`
- `Problem`
- `Muss gemacht werden`

---

## 2. Labels geben Orientierung

Labels helfen, Arbeit schneller zu verstehen.

Empfohlene Label-Gruppen:

- **Type**: `bug`, `feature`, `docs`, `research`, `ops`
- **Priority**: `P0`, `P1`, `P2`
- **State**: `blocked`, `ready`, `needs-review`
- **Area**: `website`, `automation`, `infra`, `docs`

Regel:

> Lieber wenige saubere Labels als 60 unklare Labels.

---

## 3. Branches mit Sinn anlegen

Ein Branch ist der Arbeitsraum für genau eine Änderung oder eine eng zusammenhängende Änderung.

Empfohlene Branch-Namen:

- `feat/github-discussions-guide`
- `fix/mobile-nav-overlap`
- `docs/profile-readme-guide`

Gute Regeln:

- ein Branch pro Thema
- keine Sammel-Branches für 10 verschiedene Sachen
- Branch-Namen kurz und klar

---

## 4. Pull Requests richtig nutzen

Ein Pull Request ist nicht nur der Merge-Button, sondern der offizielle Review-Raum.

Ein guter PR erklärt:

- **was** geändert wurde
- **warum** es geändert wurde
- **was nicht Teil des PR ist**
- **wie man es prüft**

### Gute PR-Struktur

```md
## What
Kurze Zusammenfassung der Änderung

## Why
Warum diese Änderung wichtig ist

## Scope
- was enthalten ist
- was bewusst nicht enthalten ist

## Validation
- getestet durch ...
- geprüft auf ...
```

---

## 5. Draft PRs früh nutzen

Wenn Arbeit noch nicht fertig ist, kann ein **Draft Pull Request** sehr hilfreich sein.

Damit kann man:

- früh Feedback holen
- Richtung abstimmen
- Review vorbereiten
- Sichtbarkeit schaffen

Regel:

> Lieber früh als Draft sichtbar sein als spät mit einer riesigen Überraschung kommen.

---

## 6. Reviews sollen besser machen, nicht blockieren

Review bedeutet:

- Logik prüfen
- Klarheit prüfen
- Risiken sehen
- Verbesserungsvorschläge machen

Review bedeutet **nicht**:

- Statusspielchen
- Ego-Debatten
- vage Kritik ohne Lösungsvorschlag

Gutes Feedback ist:

- konkret
- respektvoll
- nachvollziehbar
- lösungsorientiert

---

## 7. Issues, Projects, PRs und Discussions hängen zusammen

Die vier Bausteine haben unterschiedliche Rollen:

| Werkzeug | Aufgabe |
| :--- | :--- |
| **Discussions** | Denken, Fragen, Ideen, Klärung |
| **Issues** | konkrete verfolgte Arbeit |
| **Projects** | Priorisierung und Sicht auf den Gesamtfluss |
| **Pull Requests** | Review und Merge von Änderungen |

So entsteht ein sauberer Fluss:

**Discussion → Issue → Project → Branch → Pull Request → Merge**

Natürlich braucht nicht jedes Thema jeden Schritt, aber die Rollen sollten klar bleiben.

---

## 8. Merge-Regeln

Teams sollten einen einheitlichen Stil haben.

Für viele Teams ist sinnvoll:

- kleine bis mittlere Änderungen per **Squash Merge**
- nur gemergte PRs, die reviewbar und nachvollziehbar sind
- keine wilden Direkt-Commits auf wichtige Hauptbranches

Wichtiger als die exakte Merge-Methode ist Konsistenz.

---

## 9. Gute tägliche Zusammenarbeit auf GitHub

### Vor dem Start

- Ist das Thema als Issue sichtbar?
- Ist Priorität klar?
- Weiß jemand, wer Owner ist?

### Während der Arbeit

- Arbeite auf einem passenden Branch
- halte Änderungen thematisch sauber
- öffne Draft PR früh genug

### Vor dem Merge

- Ist die Beschreibung klar?
- Ist Review möglich?
- Sind relevante Links zu Issue oder Project enthalten?

---

## Anti-Patterns

Vermeidet:

- Arbeiten ohne Issue bei wichtigen Themen
- riesige PRs mit vielen unabhängigen Änderungen
- Reviews ohne konkreten Nutzen
- unklare Ownership
- Diskussionen im Nirgendwo statt im passenden GitHub-Raum

---

## Kurzregel

> Gute GitHub-Kollaboration macht Arbeit sichtbar, verantwortlich, reviewbar und über Zeit nachvollziehbar.

---

## Qualitäts-Check

- [ ] Wichtige Arbeit hat ein Issue
- [ ] Die Aufgabe ist in Projects sichtbar, wenn sie priorisiert werden muss
- [ ] Der Branch ist thematisch sauber
- [ ] Der PR erklärt What, Why und Validation
- [ ] Review ist konkret und hilfreich
- [ ] Der Merge hinterlässt einen nachvollziehbaren Stand
