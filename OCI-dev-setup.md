# ☁️ Oracle Cloud Infrastructure (OCI) - Dev Setup

![Oracle Cloud](https://img.shields.io/badge/Oracle_Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

Dieses Repository dokumentiert das Setup für eine **OCI Always Free Compute Instance** (ARM Ampere A1 oder AMD Micro). Da es sich um einen Headless-Server handelt, erfolgt die Entwicklung remote via SSH.

## 📋 Inhaltsverzeichnis

1. [Oracle Cloud Account erstellen & A1.Flex VM starten](#1-oracle-cloud-account-erstellen--a1flex-vm-starten)
2. [Tool-Übersicht](#2-tool-übersicht)
3. [Basis-Setup & System-Update](#3-basis-setup--system-update)
4. [Installation der Core-Tools](#4-installation-der-core-tools)
5. [Remote Development (VS Code)](#5-remote-development-vs-code)
6. [OCI Spezifisch: Firewall & Ports](#6-oci-spezifisch-firewall--ports)

---

## 1. Oracle Cloud Account erstellen & A1.Flex VM starten

> **⚠️ WICHTIG: A1.Flex Verfügbarkeit (Frankfurt, April 2026)**
> Die kostenlose A1.Flex Instanz (4 OCPUs, 24 GB RAM) ist in **fast allen Regionen stark überlaufen** — auch Frankfurt (`eu-frankfurt-1`). Frankfurt hat jedoch **3 Availability Domains (AD1, AD2, AD3)** — wenn AD1 voll ist, versuche AD2 oder AD3! Falls keine AD funktioniert, nutze den **PAYGO-Workaround** (siehe unten).

---

### Schritt 1: Oracle Cloud Free Tier Konto erstellen

**URL:** [https://www.oracle.com/cloud/free/](https://www.oracle.com/cloud/free/)

1. Klicke auf **"Start for free"**
2. Wähle **"Sign up with Google"** oder Email/Passwort
3. **Wichtig:** Bei der Registrierung als **Home Region** wählen:
   - `Germany Central (Frankfurt) — eu-frankfurt-1` ✅ (weil wir in Berlin sind)
   - Frankfurt hat 3 ADs = bessere Chance auf A1.Flex
4. Gib echte Daten ein — Oracle prüft die Telefonnummer per SMS oder Anruf
5. Zahlungsinformationen: Eine **echte Kredit-/Debitkarte** wird benötigt
   - Es wird ein **$1-100$ Test-Block** gemacht (temporär, wird nach 1-7 Tagen freigegeben)
   - Keine automatische Abrechnung solange du die Always-Free-Limits einhältst

**Häufige Fehler bei der Registrierung:**
- ❌ Falsche Telefonnummer → Oracle kann nicht verifizieren → Konto gesperrt
- ❌ Virtuelle/Prepaid-Karten → oft abgelehnt → echte Karte verwenden
- ❌ Home Region nachträglich ändern → **unmöglich!** Nur einmal bei Erstellung wählbar
- ❌ Bereits ein Oracle-Konto mit derselben Email → erst abmelden oder anderen Account nutzen

---

### Schritt 2: OCI Konsole öffnen

**URL:** [https://cloud.oracle.com/](https://cloud.oracle.com/)

Nach dem Login → Klicke auf **"Sign in to Cloud Console"** → wähle dein Konto.

---

### Schritt 3: A1.Flex Instance erstellen (4 OCPUs, 24 GB RAM — kostenlos!)

1. In der OCI Console: **Hamburger Menu → Compute → Instances**
2. Klicke **"Create Instance"**
3. Konfiguration:
   - **Name:** z.B. `sin-dev-vm`
   - **Placement:** `eu-frankfurt-1` (oder `Germany Central` auswählen)
     - ⚡ **Probiere alle 3 ADs durch** wenn "out of capacity" kommt:
       - Frankfurt hat AD1, AD2, AD3
       - Erst AD1 versuchen → wenn voll → AD2 → wenn voll → AD3
   - **Image:** `Ubuntu 22.04 LTS` oder `24.04 LTS` ✅
   - **Shape:** `VM.Standard.A1.Flex`
     - **OCPUs:** 4 (Maximum für Always Free)
     - **Memory:** 24 GB (Maximum für Always Free)
   - **Networking:** Standard belassen (Virtual Cloud Network wird automatisch erstellt)
   - **SSH Key:** Erstelle einen neuen SSH Key oder lade deinen Public Key hoch:
     ```bash
     # Auf deinem Mac: SSH Key erstellen (falls noch nicht vorhanden)
     ssh-keygen -t ed25519 -C "deine-email@beispiel.de" -f ~/.ssh/oci_key
     cat ~/.ssh/oci_key.pub  # Diesen Public Key bei Oracle einfügen
     ```
   - **Boot Volume:** Standard belassen

4. Klicke **"Create"** → Warte 2-5 Minuten bis die Instance läuft

---

### Schritt 4: PAYGO-Workaround (falls alle ADs in Frankfurt "out of capacity" zeigen)

Falls Frankfurt wirklich komplett voll ist und du keinen A1.Flex bekommst:

1. **Aufwertung auf Pay-As-You-Go** (bleibt trotzdem kostenlos!):
   - **Hamburger Menu → Billing → Manage Payment**
   - Klicke **"Upgrade to Paid Account"**
   - Oracle gibt dir **$300 kostenlose Credits** für 30 Tage
   - Du bekommst Zugang zum **anderen Kapazitäts-Pool** (weniger überlaufen)

2. **Wichtig dabei:**
   - Solange du innerhalb der **Always-Free-Limits** bleibst (4 OCPUs, 24 GB RAM, 50 GB Storage), fallen **keine Kosten an**
   - Setze sofort ein **Budget Alert** um sicherzugehen:
     - **Hamburger Menu → Billing → Budget Alerts → Create Alert** (z.B. bei $5)
   - Die $100 Card-Authorisierung wird nach ~7 Tagen automatisch freigegeben

3. Dann erneut eine A1.Flex Instance erstellen → jetzt aus dem PAYGO-Pool → deutlich höhere Erfolgschance!

---

### Schritt 5: Verbindung zur VM via SSH

Sobald die Instance läuft, kopiere die **Public IP** aus der OCI Console.

```bash
# SSH Verbindung (ersetze <PFAD_ZU_KEY> und <VM_IP>)
ssh -i ~/.ssh/oci_key ubuntu@<VM_IP>
```

---

### Schritt 6: Budget Alert setzen (Pflicht!)

1. **Hamburger Menu → Billing → Budget Alerts → Create Budget Alert**
2. Name: `Always-Free-Limit`
3. Threshold: `$5 USD` (oder niedriger)
4. Empfänger: Deine Email eintragen
5. **Speichern** ✅

> So wirst du sofort benachrichtigt falls doch mal Kosten entstehen sollten.

---

### Quick-Reference: Always-Free Limits für A1.Flex

| Ressource | Always-Free-Limit |
|-----------|-------------------|
| OCPUs | 4 |
| RAM | 24 GB |
| Boot Volume | 50 GB |
| Traffic Out | 10 TB/Monat |

Solange du innerhalb dieser Limits bleibst → **kostenlos, solange du willst**.

---

### Troubleshooting

| Problem | Lösung |
|---------|--------|
| "Out of capacity" in Frankfurt | Alle 3 ADs durchprobieren (AD1→AD2→AD3), oder PAYGO-Workaround |
| Karte wird abgelehnt | Echte Kredit/Debitkarte nutzen, keine Prepaid |
| Kein SMS-Code erhalten | Anruf statt SMS anfordern bei der Verifizierung |
| $100 werden abgebucht | Temporär — wird nach ~7 Tagen freigegeben |
| Instance startet nicht | OCI Status prüfen → ggf. andere AD oder Region versuchen |

---

## 2. Tool-Übersicht

Folgende Kernkomponenten werden auf dem Linux-Server installiert:

| Tool | Kategorie | Beschreibung | Installationsmethode |
| :--- | :--- | :--- | :--- |
| **[APT](https://ubuntu.com/)** | Paketmanager | Der Standard-Paketmanager für Ubuntu/Debian-basierte Systeme. | *Vorinstalliert* |
| **[Git](https://git-scm.com/)** | Versionskontrolle | Tracking von Code-Änderungen auf dem Server. | `apt` |
| **[Python 3](https://www.python.org/)** | Sprache | Oft vorinstalliert, wird inklusive `pip` (Package Installer) eingerichtet. | `apt` |
| **[Node.js](https://nodejs.org/)** | Runtime | JavaScript-Laufzeitumgebung (via NodeSource für aktuelle Versionen). | `apt` |
| **[Docker](https://www.docker.com/)** | Containerization | Industrie-Standard für das Ausführen von isolierten Cloud-Anwendungen. | `apt` |

---

## 3. Basis-Setup & System-Update

Als Best Practice bringen wir zuerst das gesamte System auf den neuesten Stand. Führe nach dem SSH-Login folgende Befehle aus:

```bash
# Paketlisten aktualisieren und installierte Pakete upgraden
sudo apt update && sudo apt upgrade -y

# Unnötige Pakete entfernen
sudo apt autoremove -y
```

---

## 4. Installation der Core-Tools

Nun installieren wir die eigentlichen Entwicklungswerkzeuge.

### Git & Python
Git und die grundlegenden Python-Werkzeuge installieren:

```bash
sudo apt install git python3 python3-pip python3-venv -y
```

### Node.js & NPM (LTS Version)
Die in Ubuntu enthaltene Node.js-Version ist oft veraltet. Wir nutzen das offizielle NodeSource-Repository für die aktuelle LTS (Long Term Support) Version:

```bash
# NodeSource Repo hinzufügen
curl -fsSL [https://deb.nodesource.com/setup_lts.x](https://deb.nodesource.com/setup_lts.x) | sudo -E bash -

# Node.js und NPM installieren
sudo apt install -y nodejs
```

### Docker & Docker Compose
Für eine moderne Cloud-Entwicklung ist Docker unverzichtbar:

```bash
# Docker installieren
sudo apt install docker.io docker-compose-v2 -y

# Den aktuellen Benutzer zur Docker-Gruppe hinzufügen (verhindert 'sudo' vor jedem docker-Befehl)
sudo usermod -aG docker $USER

# WICHTIG: Du musst dich einmal ab- und wieder anmelden (exit und neu per SSH verbinden), damit die Gruppenänderung greift!
```

---

## 5. Remote Development (VS Code)

Wir installieren **kein** VS Code auf dem Server! Stattdessen nutzt du dein lokales VS Code auf dem Mac, um direkt auf dem Server zu programmieren.

**Schritte auf deinem lokalen Mac:**
1. Öffne VS Code.
2. Installiere die Erweiterung **"Remote - SSH"** (von Microsoft).
3. Klicke unten links auf das grüne Icon (`><`) und wähle **"Connect to Host..."**.
4. Gib den Verbindungsstring ein: `ubuntu@<DEINE_PUBLIC_IP>`.
5. Du kannst nun Ordner auf dem Cloud-Server öffnen, bearbeiten und das Terminal direkt in VS Code nutzen.

---

## 6. OCI Spezifisch: Firewall & Ports

Oracle Cloud hat ein zweistufiges Firewall-System. Wenn du z.B. einen Webserver auf Port `8080` oder `3000` startest, musst du ihn an zwei Stellen freigeben:

### 1. In der OCI Web-Konsole (Ingress Rules)
* Navigiere zu: *Networking > Virtual Cloud Networks > [Dein VCN] > Security List*
* Füge eine neue **Ingress Rule** hinzu (Source: `0.0.0.0/0`, Destination Port: `Dein Port`).

### 2. Auf dem Server (iptables)
Ubuntu auf OCI nutzt standardmäßig strenge `iptables`-Regeln. Um z.B. Port 3000 für Node.js freizugeben, führe auf dem Server aus:

```bash
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 3000 -j ACCEPT
sudo netfilter-persistent save
```

---

## 7. OCI VM Disk Full Prevention — BUG-OCI-001 Hardening Stack

> **⚠️ CRITICAL: This section is MANDATORY for all OCI VMs running A2A agents.**
> **Date:** 2026-04-16 — Incident: BUG-OCI-001 (disk full → all 6 coder agents dead)

### What Happened (Root Cause Analysis)

On 2026-04-16, the OCI VM `92.5.60.87` became **100% disk full** due to three compounding failures:

1. **`.so` file leak** — Every call to `is_healthy()` in all 6 coder agents ran `subprocess.run(["opencode", "--version"])`, which created ~4.4 MB of temporary `.so` files in `/tmp/` per call. With 6 agents polling every ~10 seconds, this leaked **~100 MB/hour** into `/tmp/`. Python's `glob.glob(r"/tmp/.*.so")` was used in cleanup but the regex pattern was **invalid** (`.` is not `\.` in regex, so `.*.so` never matched anything).

2. **App route shadowing** — All 6 FastAPI-based agents mounted Gradio on `/` **before** registering FastAPI routes. This caused `/health` to return `404`, making the health checks useless and preventing monitoring from detecting the leak.

3. **No disk monitoring** — No systemd timer, no journald limits, no emergency stop. The VM bled disk until it hit 100% and the OCI VM itself became unresponsive.

### The Fix — 5-Layer Protection Stack

All hardening scripts are source-controlled in `Infra-SIN-Dev-Setup/scripts/` and deployed to `/usr/local/bin/` on the OCI VM.

#### Layer 1: Runner Cleanup Timer (every 5 minutes)

**Purpose:** Aggressively clean up leaked `.so` files before they accumulate.

```bash
# Script: /usr/local/bin/cleanup-runner-libs.sh
# Uses Python glob (not regex) to find /tmp/.*.so files >10 minutes old
# Deployed via: Infra-SIN-Dev-Setup/scripts/cleanup-runner-libs.sh
```

**systemd unit:**
- Timer: `runner-cleanup.timer` — fires every 5 minutes
- Service: `runner-cleanup.service` — runs the cleanup script

#### Layer 2: Space Guardian Timer (every 1 hour)

**Purpose:** Prune caches and Docker when disk ≥ 80%. Escalates to emergency guard if ≥ 85%.

```bash
# Script: /usr/local/bin/oci-space-guardian.sh
# 1. At 80%: Clean pip cache, apt cache, Docker prune -af
# 2. At 85%: Run cleanup-runner-libs.sh + oci-log-rotation.sh
# 3. If still ≥ 85%: Trigger oci-emergency-disk-guard.service
```

**systemd unit:**
- Timer: `oci-space-guardian.timer` — fires every 1 hour
- Service: `oci-space-guardian.service`

#### Layer 3: Emergency Disk Guard (every 5 minutes)

**Purpose:** Last-resort auto-stop of all 6 coder services when disk stays critical.

```bash
# Script: /usr/local/bin/oci-emergency-disk-guard.sh
# 1. Check root disk usage %
# 2. If ≥ 85%: Run cleanup-runner-libs.sh + oci-log-rotation.sh
# 3. If STILL ≥ 85%: Stop all 6 a2a-sin-code-*.service units
# 4. Log last-stop reason to /var/lib/oci-emergency-disk-guard/last-stop.txt
# 5. After stop: check disk — if < 80%, restart services
```

**systemd unit:**
- Timer: `oci-emergency-disk-guard.timer` — fires every 5 minutes
- Service: `oci-emergency-disk-guard.service`

**Emergency recovery:** If all services are stopped, run on OCI:
```bash
sudo systemctl start a2a-sin-code-backend a2a-sin-code-command a2a-sin-code-frontend a2a-sin-code-fullstack a2a-sin-code-plugin a2a-sin-code-tool
```

#### Layer 4: Log Rotation (daily)

**Purpose:** Prevent journald and syslog from consuming all disk.

```bash
# Script: /usr/local/bin/oci-log-rotation.sh
# 1. Truncate oversized syslog files if > 500MB
# 2. Vacuum journald to 200MB max, 7-day retention
# 3. Create /var/lib/oci-emergency-disk-guard/ for guard state
```

**Permanent journald limits** (deployed as drop-in):
```ini
# /etc/systemd/journald.conf.d/90-oci-limits.conf
SystemMaxUse=200M
RuntimeMaxUse=200M
SystemKeepFree=2G
MaxRetentionSec=7day
```

**systemd unit:**
- Timer: `oci-log-rotation.timer` — fires daily
- Service: `oci-log-rotation.service`

#### Layer 5: Self-Test (daily)

**Purpose:** Verify all 4 protection layers are functioning. Alert if any check fails.

```bash
# Script: /usr/local/bin/oci-disk-self-test.sh
# Runs 27 checks including:
# - All scripts are executable
# - All 4 timers are active + enabled
# - journald hardening is present
# - No "opencode --version" leak path in agent code
# - Service hardening drop-ins are present
# - Disk below 80%
# - Health endpoints return 200
# - Health checks create no new /tmp/.*.so files
```

**systemd unit:**
- Timer: `oci-disk-self-test.timer` — fires daily at 03:00
- Service: `oci-disk-self-test.service`

### Quick Verify (on OCI VM)

```bash
# Disk status
df -h /

# All 5 timers active?
systemctl list-timers | grep -E "runner-cleanup|oci-space-guardian|oci-emergency-disk-guard|oci-log-rotation|oci-disk-self-test"

# All 6 agents running?
systemctl is-active a2a-sin-code-backend a2a-sin-code-command a2a-sin-code-frontend a2a-sin-code-fullstack a2a-sin-code-plugin a2a-sin-code-tool

# Run self-test (27 checks)
sudo /usr/local/bin/oci-disk-self-test.sh

# Emergency: stop all agents manually
sudo systemctl stop a2a-sin-code-backend a2a-sin-code-command a2a-sin-code-frontend a2a-sin-code-fullstack a2a-sin-code-plugin a2a-sin-code-tool

# Emergency: restart all agents
sudo systemctl start a2a-sin-code-backend a2a-sin-code-command a2a-sin-code-frontend a2a-sin-code-fullstack a2a-sin-code-plugin a2a-sin-code-tool
```

### Agent-Level Fixes (also applied)

1. **`is_healthy()` no longer calls `opencode --version`** — Changed to `shutil.which("opencode")` (zero file creation). Deployed to all 6 agents live and in all 6 GitHub repos.

2. **Health route before Gradio mount** — FastAPI routes registered BEFORE `app.mount()` so `/health` returns `200`. Fixed in all 6 agents.

3. **Service crash storm hardening** — All 6 agents have systemd drop-ins:
   ```ini
   [Service]
   StartLimitIntervalSec=300
   StartLimitBurst=3
   Restart=on-failure
   RestartSec=30
   ExecStartPre=-/usr/local/bin/cleanup-runner-libs.sh
   ```

### Installation (fresh OCI VM)

```bash
# From Mac — deploy full hardening stack to OCI VM
scp -i ~/.ssh/oci_key -r ~/dev/Infra-SIN-Dev-Setup/scripts/*.sh ubuntu@92.5.60.87:/tmp/
scp -i ~/.ssh/oci_key -r ~/dev/Infra-SIN-Dev-Setup/systemd/*.timer ubuntu@92.5.60.87:/tmp/
scp -i ~/.ssh/oci_key -r ~/dev/Infra-SIN-Dev-Setup/systemd/*.service ubuntu@92.5.60.87:/tmp/
scp -i ~/.ssh/oci_key -r ~/dev/Infra-SIN-Dev-Setup/systemd/*.conf ubuntu@92.5.60.87:/tmp/

# On OCI VM:
bash /tmp/Infra-SIN-Dev-Setup/scripts/install-a2a-sin-code-hardening.sh
```

Full source-controlled installation script: `Infra-SIN-Dev-Setup/scripts/install-a2a-sin-code-hardening.sh`
