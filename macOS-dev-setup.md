# 💻 macOS Development Environment Setup

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Homebrew](https://img.shields.io/badge/homebrew-%23F0A84D.svg?style=for-the-badge&logo=homebrew&logoColor=black)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

Dieses Repository dokumentiert den standardisierten Setup-Prozess für eine macOS-Entwicklungsumgebung. Es führt durch die Installation und Konfiguration der essenziellen Werkzeuge, die für den Entwicklungsalltag benötigt werden.

## 📋 Inhaltsverzeichnis

1. [Voraussetzungen](#1-voraussetzungen)
2. [Tool-Übersicht](#2-tool-übersicht)
3. [Schritt-für-Schritt Installation](#3-schritt-für-schritt-installation)
4. [Konfiguration & Best Practices](#4-konfiguration--best-practices)

---

## 1. Voraussetzungen

Bevor das Setup gestartet wird, müssen folgende Voraussetzungen erfüllt sein:
* Ein macOS-System (Intel oder Apple Silicon)
* Administratorrechte auf dem Gerät
* Eine aktive Internetverbindung

---

## 2. Tool-Übersicht

Folgende Kernkomponenten werden in diesem Setup installiert:

| Tool | Kategorie | Beschreibung | Installationsmethode |
| :--- | :--- | :--- | :--- |
| **[Homebrew](https://brew.sh/)** | Paketmanager | Der De-facto-Standard-Paketmanager für macOS, um alle weiteren Tools zu verwalten. | `curl` / `bash` |
| **[Git](https://git-scm.com/)** | Versionskontrolle | Tracking von Code-Änderungen und Zusammenarbeit im Team. | `brew` |
| **[VS Code](https://code.visualstudio.com/)** | Code Editor | Hochgradig anpassbare Entwicklungsumgebung von Microsoft. | `brew --cask` |
| **[Python](https://www.python.org/)** | Sprache | Vielseitige Programmiersprache für Skripte, Backend und Datenverarbeitung. | `brew` |
| **[Node.js & NPM](https://nodejs.org/)** | Runtime & Packages | JavaScript-Laufzeitumgebung und der dazugehörige Paketmanager. | `brew` |

---

## 3. Schritt-für-Schritt Installation

Öffne das Programm **Terminal** (zu finden unter *Programme > Dienstprogramme*) und führe die folgenden Befehle nacheinander aus.

### Phase 1: Die Basis schaffen

Zuerst installieren wir die Apple-Entwicklerwerkzeuge und den Paketmanager Homebrew.

```bash
# 1. Xcode Command Line Tools installieren
xcode-select --install

# 2. Homebrew installieren
/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
```
> **⚠️ Wichtig:** Lies nach der Homebrew-Installation die Terminal-Ausgabe. Dort stehen meist 2-3 Befehle unter "Next steps", die du ausführen musst, um Homebrew zu deinem `PATH` hinzuzufügen.

### Phase 2: Core-Tools installieren

Sobald Homebrew einsatzbereit ist, können die restlichen Werkzeuge automatisiert installiert werden:

```bash
# Terminal-Tools und Sprachen installieren
brew install git python node

# Visual Studio Code als grafische Anwendung installieren
brew install --cask visual-studio-code
```

### Phase 3: Installation verifizieren

Prüfe, ob alle Pfade korrekt gesetzt sind und die Tools antworten:

```bash
git --version
python3 --version
node --version
npm --version
code --version
```

---

## 4. Konfiguration & Best Practices

Damit die Tools reibungslos zusammenarbeiten, müssen nach der Installation noch einige Grundeinstellungen vorgenommen werden.

### Git Setup
Setze deine globalen Benutzerdaten, damit Commits dir korrekt zugeordnet werden:

```bash
git config --global user.name "Dein Vorname Dein Nachname"
git config --global user.email "deine.email@beispiel.de"
git config --global init.defaultBranch main
```

### VS Code Erweiterungen (Empfohlen)
Für ein optimales Erlebnis empfehlen wir die Installation folgender Extensions direkt in VS Code:
* **Prettier** - Code formatter
* **GitLens** - Erweiterte Git-Funktionen
* **Python** (von Microsoft)
