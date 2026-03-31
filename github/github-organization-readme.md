# GitHub-Organization-README

Diese Anleitung erklärt, was eine GitHub Organization ist, warum sie für Teams wichtig ist und wie wir sie bei OpenSIN sauber nutzen.

## Was ist eine GitHub Organization?

Eine GitHub Organization ist der gemeinsame Arbeitsraum für ein Team, eine Firma oder eine Community.

Statt dass alle Repositories unter einzelnen Privataccounts liegen, gehören sie einer gemeinsamen Struktur.

Das bringt Ordnung, klare Verantwortlichkeiten und bessere Zusammenarbeit.

---

## Warum eine Organization besser ist als nur persönliche Accounts

Mit einer Organization bekommt ihr:

- **gemeinsame Besitzstruktur** statt Einzelabhängigkeit
- **Teams und Rollen** statt Chaos
- **zentrale Rechteverwaltung**
- **bessere Onboarding- und Offboarding-Prozesse**
- **gemeinsame Sichtbarkeit nach außen**
- **ein professionelles Zuhause für alle Repos**

Kurz:

> Eine Organization ist das Betriebsmodell für ernsthafte Teamarbeit auf GitHub.

---

## Die wichtigsten Bausteine einer Organization

### 1. Owners

Owners haben weitreichende Rechte.
Sie können unter anderem:

- Mitglieder verwalten
- Teams anlegen
- Repository-Rechte ändern
- Sicherheits- und Abrechnungssettings ändern

Regel:

> Owners sollten wenige sein. Nicht jeder im Team braucht Owner-Rechte.

### 2. Members

Members sind normale Organisationsmitglieder.
Sie arbeiten in Teams und Repositories, ohne alles administrieren zu müssen.

### 3. Teams

Teams sind die wichtigste Struktur innerhalb einer Organization.

Beispiele:

- `core`
- `frontend`
- `automation`
- `docs`
- `research`
- `ops`

Über Teams steuert ihr:

- Repository-Zugriff
- Review-Verantwortung
- klare Zuständigkeiten

### 4. Repositories

Die Repositories sind die eigentlichen Arbeitsräume.
Sie sollten klar benannt, thematisch sauber und für das Team nachvollziehbar strukturiert sein.

---

## Wie OpenSIN eine Organization nutzen sollte

Für OpenSIN sollte die Organization nicht nur ein Repo-Container sein, sondern ein klarer Betriebsraum.

### Ziele

- gemeinsame sichtbare Markenpräsenz
- klare Teamstruktur
- sauberes Rechtekonzept
- nachvollziehbare Verantwortung
- schnellere Zusammenarbeit

### Praktischer Nutzen

- neue Mitglieder können sauber eingeladen werden
- Zugriffe lassen sich über Teams vergeben statt einzeln
- wenn eine Person geht, bleiben Repos, Prozesse und Wissen im System
- Außenstehende sehen ein professionelles Gesamtbild

---

## Das Profil einer Organization

Auch eine GitHub Organization kann eine eigene Profilseite mit README haben.

### Technische Einrichtung

Dafür braucht die Organization ein **öffentliches Repository mit dem Namen `.github`**.

Darin liegt diese Datei:

```text
profile/README.md
```

Beispiel:

```text
.github/profile/README.md
```

Diese README wird dann auf der Profilseite der Organisation angezeigt.

---

## Warum man manche Mitglieder in einer Organization nicht sieht

GitHub unterscheidet bei Organisationsmitgliedern zwischen:

- **private membership**
- **public membership**

Wenn Mitglieder auf **private** stehen, erscheinen sie **nicht öffentlich** auf der Org-Seite.

Wichtig für Owners:

> Du kannst als Org-Owner andere Mitglieder **nicht zentral öffentlich schalten**. GitHub erlaubt das nur der jeweiligen Person selbst.

Das ist eine GitHub-Regel und kein Konfigurationsfehler von OpenSIN.

### Was das für OpenSIN bedeutet

Wenn OpenSIN-Mitglieder öffentlich auf der Org-Seite sichtbar sein sollen, muss **jede Person die eigene Mitgliedschaft selbst auf public stellen**.

### Schnellster Weg in der GitHub-Oberfläche

1. GitHub öffnen
2. `OpenSIN-AI` aufrufen
3. Bereich **People** öffnen
4. Bei der eigenen Mitgliedschaft die Sichtbarkeit von **Private** auf **Public** umstellen

### CLI-Weg für das jeweilige Mitglied

Jede Person kann es auch selbst per GitHub CLI tun:

```bash
gh auth refresh -h github.com -s write:org
gh api -X PUT /orgs/OpenSIN-AI/public_members/$(gh api user --jq .login)
```

### Sichtbarkeit prüfen

```bash
gh api /orgs/OpenSIN-AI/public_members --jq '.[].login'
```

Wenn dort dein Username erscheint, bist du öffentlich sichtbar.

---

## Was in ein gutes Organization-Profil gehört

Eine starke Org-README sollte beantworten:

- Wer sind wir?
- Was bauen wir?
- Wofür stehen wir?
- Welche wichtigen Repositories gibt es?
- Wie kann man mitmachen oder Kontakt aufnehmen?

### Empfohlene Struktur

1. **Kurze Positionierung**
2. **Mission / Fokus**
3. **Wichtige Repositories**
4. **Wie wir arbeiten**
5. **Mitmachen / Kontakt**

---

## OpenSIN-Empfehlung für Orga-Struktur

### Team-Struktur

Empfohlene Basis-Teams:

- `owners` – nur sehr kleiner Kreis
- `core` – technische Kernverantwortung
- `docs` – Dokumentation und Struktur
- `research` – Recherche und Wissensaufbereitung
- `ops` – Betrieb, Deployment, Infrastruktur

### Rechte-Modell

- Owner-Rechte nur für wenige Personen
- Schreibrechte bevorzugt über Teams statt über Einzelpersonen
- Repos nach Verantwortungsbereich zuweisen
- Admin-Rechte sparsam vergeben

---

## Naming und Ordnung

Je klarer Repos benannt sind, desto besser versteht das Team die Landschaft.

Beispiele:

- `dev-setup`
- `website-my.opensin.ai`
- `website-opensin.ai`
- `internal-automation`
- `docs-playbooks`

Regel:

> Repo-Namen sollen Zweck und Inhalt sofort erkennbar machen.

---

## Was nicht in die Organization gehört

Vermeidet:

- private Spielrepos ohne erkennbaren Zweck
- unsaubere Namenskonventionen
- Owner-Rechte für zu viele Leute
- unklare Teamzuordnung
- Repositories ohne Verantwortliche

---

## Copy-Paste-Struktur für eine Org-README

```md
# OpenSIN

OpenSIN ist unser gemeinsamer Arbeitsraum für Systeme, Tools, Websites, Automationen und operative Entwicklungsprozesse.

## Fokus

- AI-first Workflows
- Tools mit echtem Hebel
- Dokumentation, Struktur und schnelle Umsetzbarkeit

## Wichtige Repositories

- [dev-setup](https://github.com/OpenSIN-AI/dev-setup)
- [website-my.opensin.ai](https://github.com/OpenSIN-AI/website-my.opensin.ai)

## Wie wir arbeiten

- klare Ownership
- strukturierte Issues und Pull Requests
- sichtbare Dokumentation

## Kontakt

- GitHub Organization: https://github.com/OpenSIN-AI
```

---

## Qualitäts-Check

- [ ] Rollen und Teams sind klar
- [ ] Owner-Kreis ist klein und bewusst gewählt
- [ ] Wichtige Repositories sind sichtbar
- [ ] Rechte werden über Teams statt über Chaos verwaltet
- [ ] Die Org-README erklärt klar, wofür die Organisation steht
