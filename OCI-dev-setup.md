# ☁️ Oracle Cloud Infrastructure (OCI) - Dev Setup

![Oracle Cloud](https://img.shields.io/badge/Oracle_Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

Dieses Repository dokumentiert das Setup für eine **OCI Always Free Compute Instance** (ARM Ampere A1 oder AMD Micro). Da es sich um einen Headless-Server handelt, erfolgt die Entwicklung remote via SSH.

## 📋 Inhaltsverzeichnis

1. [Voraussetzungen](#1-voraussetzungen)
2. [Tool-Übersicht](#2-tool-übersicht)
3. [Basis-Setup & System-Update](#3-basis-setup--system-update)
4. [Installation der Core-Tools](#4-installation-der-core-tools)
5. [Remote Development (VS Code)](#5-remote-development-vs-code)
6. [OCI Spezifisch: Firewall & Ports](#6-oci-spezifisch-firewall--ports)

---

## 1. Voraussetzungen

Bevor das Setup gestartet wird, müssen folgende Punkte auf der OCI-Plattform erledigt sein:
* Eine laufende OCI Compute Instance (Empfohlenes Image: **Ubuntu 22.04 LTS** oder **24.04 LTS**)
* Ein konfiguriertes SSH-Schlüsselpaar für den Zugriff
* Die öffentliche IP-Adresse der VM

Verbindung zum Server herstellen (vom lokalen Mac):
```bash
ssh -i /pfad/zu/deinem/privaten_schlüssel ubuntu@<DEINE_PUBLIC_IP>
```

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
