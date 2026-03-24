# 🤖 OpenCode CLI - Setup & Config

![OpenCode](https://img.shields.io/badge/OpenCode-AI_Agent-000000?style=for-the-badge&logo=terminal&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

Dieses Dokument beschreibt die Installation und Konfiguration der **OpenCode CLI** – einem leistungsstarken KI-Coding-Agenten für das Terminal. OpenCode ermöglicht es, direkt im Terminal mit verschiedenen LLMs (wie Gemini, Claude, Grok, etc.) Code zu generieren, zu bearbeiten und Dateien zu verwalten.

## 📋 Inhaltsverzeichnis

1. [Voraussetzungen](#1-voraussetzungen)
2. [Installation](#2-installation)
3. [API-Schlüssel einrichten](#3-api-schlüssel-einrichten)
4. [Konfiguration (opencode.json)](#4-konfiguration-opencodejson)
5. [Die wichtigsten Befehle](#5-die-wichtigsten-befehle)

---

## 1. Voraussetzungen

OpenCode läuft auf allen gängigen Betriebssystemen. Für dieses Setup setzen wir voraus:
* Ein modernes Terminal (z.B. iTerm2, WezTerm oder das integrierte VS Code Terminal)
* API-Schlüssel für deinen bevorzugten KI-Anbieter (z.B. Google Gemini, Anthropic, OpenAI oder Grok)

---

## 2. Installation

Du kannst OpenCode auf verschiedene Arten installieren. Wähle die Methode, die am besten zu deinem System passt:

### Option A: Über das offizielle Install-Skript (Mac/Linux)
Der schnellste Weg für Unix-basierte Systeme:
```bash
curl -fsSL [https://opencode.ai/install](https://opencode.ai/install) | bash
```

### Option B: Über NPM (Plattformübergreifend)
Falls du Node.js bereits installiert hast (siehe `macOS-dev-setup.md`), kannst du OpenCode global über NPM installieren:
```bash
npm install -g opencode-ai@latest
```

### Option C: Über Homebrew (macOS)
```bash
brew install anomalyco/tap/opencode
```

---

## 3. API-Schlüssel einrichten

Damit OpenCode funktioniert, musst du dich entweder über `opencode auth login` anmelden oder die API-Schlüssel der jeweiligen Anbieter als Umgebungsvariablen setzen. 

Um die Schlüssel dauerhaft auf deinem Mac/Linux zu speichern, füge sie in deine `~/.zshrc` oder `~/.bashrc` ein:

```bash
# Beispiel für Google Gemini
export GEMINI_API_KEY="dein-api-key-hier"

# Beispiel für Anthropic (Claude)
export ANTHROPIC_API_KEY="dein-api-key-hier"
```
*(Vergiss nicht, das Terminal danach neu zu starten oder `source ~/.zshrc` auszuführen).*

---

## 4. Konfiguration (opencode.json)

OpenCode lässt sich stark anpassen. Du kannst globale Einstellungen festlegen oder projektbezogene Konfigurationen in einer `opencode.json` im Hauptverzeichnis deines Projekts speichern.

Beispiel für eine `opencode.json` (Projekt-Root):
```json
{
  "provider": {
    "model": "google/gemini-2.5-pro",
    "timeout": 600
  },
  "permission": {
    "bash": "allow",
    "edit": "allow"
  }
}
```
*Tipp: Globale Einstellungen können auf macOS/Linux unter `~/.config/opencode/opencode.json` abgelegt werden.*

---

## 5. Die wichtigsten Befehle

Sobald alles installiert ist, kannst du OpenCode direkt in deinem Projektordner starten:

| Befehl | Beschreibung |
| :--- | :--- |
| `opencode` | Startet das interaktive TUI (Terminal User Interface) im aktuellen Ordner. |
| `opencode run "Mach X"` | Führt eine Aufgabe "headless" (ohne interaktives UI) aus – perfekt für Automatisierungen. |
| `opencode serve` | Startet einen lokalen HTTP-Server für API-Zugriff ohne TUI. |
| `opencode --version` | Überprüft die aktuell installierte Version. |

**Tastenkürzel im TUI:**
* `Ctrl + ?` öffnet die Hilfe und zeigt alle verfügbaren Shortcuts.
* Mit `/connect` kannst du dich direkt in der TUI bei Providern authentifizieren.
