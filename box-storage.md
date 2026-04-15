# Box.com Storage — Cloud-Speicher für OpenSIN-AI

<p align="center">
<a href="https://github.com/OpenSIN-AI/Infra-SIN-Dev-Setup/blob/main/LICENSE">
<img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" />
</a>
<img src="https://img.shields.io/badge/Box.com-10GB_free-0061D5?logo=box&logoColor=white" alt="Box.com" />
<img src="https://img.shields.io/badge/status-Production%20Ready-1b5e20" alt="Status" />
<img src="https://img.shields.io/github/last-commit/OpenSIN-AI/Infra-SIN-Dev-Setup" alt="Last Commit" />
</p>

<p align="center">
<a href="#was-ist-das">Was ist das?</a> · <a href="#schnellstart">Schnellstart</a> · <a href="#folder-ids">Folder-IDs</a> · <a href="#cors">CORS</a> · <a href="#deployment">Deployment</a> · <a href="#troubleshooting">Probleme lösen</a>
</p>

<a name="was-ist-das"></a>

---

## Was ist das?

> **Du hast 10 GB kostenlosen Cloud-Speicher, auf den deine AI-Agents direkt zugreifen können.**
>
> Egal ob Logs, Screenshots, Videos oder Backups — deine Agenten speichern alles direkt in Box.com, ohne lokale Festplatten-Limits.

### Use Cases — Wer braucht was?

| Wer | Problem | Lösung |
|:---|:---|:---|
| **Developer** | Logs von verschiedenen VMs werden nicht zentralisiert | Agenten laden automatisch hoch → alle Logs an einem Ort |
| **DevOps** | Screenshots nach Browser-Crashs verloren | Automatischer Box-Upload bei jedem Step |
| **Marketing** | Content-Dateien für verschiedene Agenten freigeben | Public Folder mit "Jeder mit Link" → sofortiger Zugriff |
| **Alle Team-Members** | Speicherplatz auf dem Mac begrenzt | Box.com als zentraler Cloud-Speicher (unbegrenzt skalierbar) |

### Architektur — So funktioniert's

```mermaid
flowchart TB
    subgraph BoxCom["Box.com Cloud"]
        PUB[Public Folder<br/>ID: 376915767916]
        CACHE[Cache Folder<br/>ID: 376701205578]
    end

    subgraph Agenten["Deine AI Agents"]
        A1[A2A-SIN-Box-Storage<br/>Service]
        A2[Beliebiger Agent<br/>mit Storage-Need]
    end

    subgraph Netzwerk["Netzwerk"]
        URL[http://room-09-box-storage:3000]
        API[Box REST API<br/>api.box.com]
    end

    A2 -->|POST /upload| A1
    A1 -->|PUT file| URL
    URL -->|CORS| API
    API -->|Speichern| PUB
    API -->|Speichern| CACHE

    classDef boxClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef agentClass fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    classDef networkClass fill:#fff3e0,stroke:#e65100,stroke-width:2px

    class A1,A2 agentClass
    class PUB,CACHE boxClass
    class URL,API networkClass
```

**Erklärung:**
- **Public Folder** = Für Dateien, die ALLE sehen dürfen (z.B. fertige Reports)
- **Cache Folder** = Für temporäre Dateien (Logs, Screenshots, Debug-Artefakte)

<p align="right">(<a href="#was-ist-das">back to top</a>)</p>

---

<a name="schnellstart"></a>

## Schnellstart — In 3 Schritten einsatzbereit

<table>
<tr>
<td width="33%" align="center">
<strong>1. CORS aktivieren</strong><br/><br/>
Box Developer Console öffnen und Domänen eintragen
</td>
<td width="33%" align="center">
<strong>2. .env konfigurieren</strong><br/><br/>
Token und Folder-IDs eintragen
</td>
<td width="33%" align="center">
<strong>3. Service starten</strong><br/><br/>
<code>docker compose up -d room-09-box-storage</code>
</td>
</tr>
</table>

> [!TIP]
> **Kein Developer Token nötig für's Deployment!** Der Service läuft mit dem vorinstallierten Token. CORS musst du nur einmalig in der Box Developer Console aktivieren.

<p align="right">(<a href="#was-ist-das">back to top</a>)</p>

---

<a name="folder-ids"></a>

## Ordner-IDs — Welche ID nutze ich?

> [!IMPORTANT]
> **Die Box API nutzt NUR numerische IDs, NIEMALS Share-Link-Slugs!**

### Verifizierte IDs für dieses Konto

| Ordner | Numerische ID | Share-URL (nur für Menschen!) |
|:---|:---|:---|
| **Public** | `376915767916` | https://app.box.com/s/mvurec77pppyqhxb09z1dwcf8bz4o7eu |
| **Cache** | `376701205578` | https://app.box.com/s/9s5htoefw1ux9ajaqj656v9a02h7z7x1 |

> [!WARNING]
> Wenn du die Share-URL in der API nutzt → **404 Error**! Share-Links sind nur für den Browser, nicht für API-Calls.

### Meine eigene Folder-ID finden

```bash
# Alle Ordner im Account auflisten
curl -s -X GET "https://api.box.com/2.0/folders/0/items" \
  -H "Authorization: Bearer DEIN_TOKEN"
```

Suche nach `"id": "1234567890"` in der Antwort — das ist deine numerische Folder-ID.

<p align="right">(<a href="#was-ist-das">back to top</a>)</p>

---

<a name="cors"></a>

## CORS aktivieren — Die häufigste Fehlerquelle

> [!CAUTION]
> **Wenn dein Service nicht in der CORS-Liste ist, werden ALLE API-Calls blockiert!**
> Box gibt dann oft einen 404 oder 403 aus — obwohl das Problem CORS ist.

### Schritt-für-Schritt

<details open>
<summary>1. Box Developer Console öffnen</summary>

Gehe zu: **https://account.box.com/developers/console**

Wähle deine App aus (z.B. `OpenSIN`).
</details>

<details open>
<summary>2. CORS-Domänen eintragen</summary>

Scrolle nach unten zum Bereich **"CORS-Domänen"** (oder "Zulässige Domänen").

Trage ein:
```
http://localhost:3000, http://room-09-box-storage:3000
```

Klicke auf **Änderungen speichern**.
</details>

<details>
<summary>3. Verifizieren dass es funktioniert</summary>

```bash
# Test: Account-Info abrufen
curl -s -X GET "https://api.box.com/2.0/users/me" \
  -H "Authorization: Bearer f9PURW50E47k9dwoVKkBD64QLJLnC4Nx"
```

Wenn du eine JSON-Antwort mit deinem Namen siehst → CORS funktioniert!
</details>

> [!NOTE]
> **Jede Domain die auf die Box API zugreift, muss in der CORS-Liste sein.** Wenn du später eine neue VM oder einen neuen Service hinzufügst, musst du die Domain dort eintragen.

<p align="right">(<a href="#was-ist-das">back to top</a>)</p>

---

<a name="deployment"></a>

## Deployment — Service aufsetzen

### Checkliste vor dem Start

- [ ] CORS-Domänen in Box Developer Console eingetragen
- [ ] Ordner "Public" und "Cache" existieren in Box.com
- [ ] `.env` Datei mit korrekten Werten erstellt

### .env Konfiguration

```env
# Box.com Storage (A2A-SIN-Box-Storage)
BOX_STORAGE_URL=http://room-09-box-storage:3000
BOX_STORAGE_API_KEY=DEIN_SICHERER_KEY_MIN_32_ZEICHEN
BOX_DEVELOPER_TOKEN=f9PURW50E47k9dwoVKkBD64QLJLnC4Nx
BOX_PUBLIC_FOLDER_ID=376915767916
BOX_CACHE_FOLDER_ID=376701205578
```

> [!TIP]
> **BOX_STORAGE_API_KEY** — Den findest du in deiner Passwort-Datenbank oder frage den Team-Lead.

### Service starten

```bash
# Service starten
docker compose up -d room-09-box-storage

# Prüfen ob er läuft
docker ps | grep box-storage
```

<p align="right">(<a href="#was-ist-das">back to top</a>)</p>

---

<a name="troubleshooting"></a>

## Probleme lösen

### Problem: "404 Error" bei Uploads

> [!WARNING]
> Das liegt fast immer an falschen Folder-IDs — NICHT an fehlenden Berechtigungen!

**Lösung:** Prüfe ob du die **numerische ID** nutzt (z.B. `376915767916`) und NICHT die Share-URL.

---

### Problem: "403 Error" oder "Access Denied"

**Mögliche Ursachen:**

| Ursache | Prüfung | Lösung |
|:---|:---|:---|
| CORS Block | Browser Console öffnen → CORS Fehler? | Domain in Box Developer Console eintragen |
| Token abgelaufen | Token älter als 60 Minuten? | Neuen Developer Token generieren |
| Falsche Berechtigungen | Ordner für App freigegeben? | In Box.com: Ordner → Teilen → App hinzufügen |

---

### Problem: Token läuft nach 1 Stunde ab

**Lösung für Produktion: JWT Authentication**

<details>
<summary>JWT Setup (für Dauerbetrieb)</summary>

1. Gehe in der App-Konfiguration zu **"Authentifizierungsmethode"**
2. Ändere auf **"OAuth 2.0 mit JWT (Serverauthentifizierung)"**
3. Generiere ein Public/Private Keypair (JSON-Datei)
4. Autorisiere die App in der Box Admin-Konsole
5. Die JSON-Keyfile ermöglicht dem Container autonome Token-Generierung

> [!NOTE]
> Mit JWT musst du dich nie wieder um Token-Refresh kümmern — der Service generiert automatisch neue Tokens.
</details>

---

### Problem: Ich weiß nicht welche Folder-ID ich habe

```bash
# Alle Ordner auflisten
curl -s -X GET "https://api.box.com/2.0/folders/0/items" \
  -H "Authorization: Bearer DEIN_TOKEN" | python3 -m json.tool
```

Suche nach dem `"name"` Feld und kopiere die zugehörige `"id"` — das ist deine Folder-ID.

<p align="right">(<a href="#was-ist-das">back to top</a>)</p>

---

## API Test — Schnellprüfung

```bash
# 1. Bin ich eingeloggt?
curl -s -X GET "https://api.box.com/2.0/users/me" \
  -H "Authorization: Bearer f9PURW50E47k9dwoVKkBD64QLJLnC4Nx"

# Erwartet: {"type":"user","id":50440114812,"name":"Jeremy Schulze",...}

# 2. Welche Ordner gibt es?
curl -s -X GET "https://api.box.com/2.0/folders/0/items" \
  -H "Authorization: Bearer f9PURW50E47k9dwoVKkBD64QLJLnC4Nx"

# 3. Test-Upload (ersetzt FOLDER_ID mit deiner ID)
curl -s -X POST "https://upload.box.com/api/2.0/files/content" \
  -H "Authorization: Bearer f9PURW50E47k9dwoVKkBD64QLJLnC4Nx" \
  -F attributes='{"name":"test.txt","parent":{"id":"FOLDER_ID"}}' \
  -F file=@/dev/null
```

> [!TIP]
> Alle Befehle funktionieren 1:1 in deinem Terminal. Kopiere, einfügen, fertig.

---

## Nützliche Links

| Ressource | URL |
|:---|:---|
| Box Developer Console | https://account.box.com/developers/console |
| Box API Dokumentation | https://developer.box.com/reference/ |
| A2A-SIN-Box-Storage Repo | https://github.com/OpenSIN-AI/A2A-SIN-Box-Storage |

---

<p align="center">
<a href="https://opensin.ai">
<img src="https://img.shields.io/badge/🤖_Powered_by-OpenSIN--AI-7B3FE4?style=for-the-badge&logo=github&logoColor=white" alt="Powered by OpenSIN-AI" />
</a>
</p>

<p align="center">
<sub>Entwickelt vom <a href="https://opensin.ai"><strong>OpenSIN-AI</strong></a> Ökosystem – Enterprise AI Agents die autonom arbeiten.</sub><br/>
<sub>🌐 <a href="https://opensin.ai">opensin.ai</a> · 💬 <a href="https://opensin.ai/agents">Alle Agenten</a> · 🚀 <a href="https://opensin.ai/dashboard">Dashboard</a></sub>
</p>

<p align="right">(<a href="#was-ist-das">back to top</a>)</p>