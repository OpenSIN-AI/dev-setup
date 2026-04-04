# 🚀 Development Environment Setup

![Repo Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Oracle Cloud](https://img.shields.io/badge/Oracle_Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)

Willkommen im zentralen **Dev-Setup Repository**. 

Dieses Projekt dokumentiert die standardisierten Entwicklungs- und Serverumgebungen. Ziel ist es, den Onboarding-Prozess für neue Systeme zu beschleunigen, Best Practices zu etablieren und die Infrastruktur konsistent und reproduzierbar zu halten.

---

## 📂 Repository Struktur

Da sich lokale Entwicklung und Cloud-Hosting grundlegend unterscheiden, ist die Dokumentation in zwei dedizierte Bereiche unterteilt. Wähle die Umgebung aus, die du einrichten möchtest:

| Umgebung | Zieldatei | Beschreibung |
| :--- | :--- | :--- |
| **💻 Lokal (macOS)** | [`macOS-dev-setup.md`](./macOS-dev-setup.md) | Leitfaden für die Einrichtung eines lokalen Apple-Rechners (Intel/Silicon) inkl. Homebrew, VS Code und Kernwerkzeugen. |
| **☁️ Cloud (OCI)** | [`OCI-dev-setup.md`](./OCI-dev-setup.md) | Leitfaden für die Einrichtung einer *Oracle Cloud Infrastructure* Ubuntu-VM, fokussiert auf Headless-Betrieb, Docker und Remote-SSH. |
| **🐙 GitHub Guides** | [`github/README.md`](./github/README.md) | Interne Leitfäden für Profil, Organization, Projects, Discussions und Collaboration auf GitHub. |

---

## 🎯 Leitprinzipien dieses Setups

* **Reproduzierbarkeit:** Alle Schritte sind so dokumentiert, dass ein System von Grund auf neu aufgesetzt werden kann.
* **Modernes Tooling:** Fokus auf aktuelle Industriestandards (Homebrew, Docker, NVM/NodeSource).
* **Remote-First (Cloud):** Die OCI-Umgebung ist speziell für die nahtlose Remote-Entwicklung via VS Code SSH optimiert.

---

## 🛠️ Verwendung

1. Klone dieses Repository auf dein lokales System oder deinen Server:
   ```bash
   git clone https://github.com/OpenSIN-AI/dev-setup.git
   cd dev-setup
   ```
2. Öffne die für dein System relevante Markdown-Datei.
3. Folge den dort beschriebenen Schritt-für-Schritt-Anleitungen.

---

## 🔗 OpenSIN-AI Ökosystem

- **Organisation:** https://github.com/OpenSIN-AI
- **Setup & Guides:** https://github.com/OpenSIN-AI/dev-setup
- **Dokumentation:** https://github.com/OpenSIN-AI/documentation
- **Website:** https://opensin.pages.dev

---

## 🤝 Beitragende

Wenn du Tools hinzufügen oder Config-Anpassungen vorschlagen möchtest, öffne gerne einen Pull Request oder erstelle ein Issue.

Lies vorher die [Contributing Guidelines](https://github.com/OpenSIN-AI/.github/blob/main/CONTRIBUTING.md) und den [GitHub Collaboration Guide](./github/github-collaboration-readme.md).

## 📚 Documentation

This repository follows the [Global Dev Docs Standard](https://github.com/OpenSIN-AI/Global-Dev-Docs-Standard).

For contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).
For security policy, see [SECURITY.md](SECURITY.md).
For the complete OpenSIN ecosystem, see [OpenSIN-AI Organization](https://github.com/OpenSIN-AI).
