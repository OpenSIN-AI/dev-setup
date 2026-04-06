# OpenCode CLI — Docker Setup

## Schnellstart

### A) ERSTMALIGES SETUP (nur 1x pro Mac/VM)

**Schritt 1: Repo holen**

```bash
# Falls noch nicht vorhanden:
git clone https://github.com/OpenSIN-AI/Infra-SIN-Dev-Setup.git
```

**Schritt 2: Rein gehen, Binary laden, Image bauen**

```bash
cd ~/Infra-SIN-Dev-Setup/opencode-docker-build
./download-binary.sh
docker build -t oc .
```

**Schritt 2: Rein gehen, Binary laden, Image bauen**

```bash
cd ~/Infra-SIN-Dev-Setup/opencode-docker-build
./download-binary.sh
docker build -t oc .
```

**Fertig. Image `oc` existiert jetzt lokal. Plugins (oh-my-opencode, antigravity-auth) sind bereits installiert.**

---

### B) DANACH: CONTAINER STARTEN

**Neue Maschine erstellen + öffnen:**

```bash
docker volume create oc-1-data
docker run -it -v oc-1-data:/root/.local/share/opencode --name oc-1 --entrypoint bash oc
```

**Nummer hochzählen für jede neue Maschine:**

```bash
docker volume create oc-2-data
docker run -it -v oc-2-data:/root/.local/share/opencode --name oc-2 --entrypoint bash oc
```

**Existierende Maschine wieder öffnen:**

```bash
docker start -i oc-1
```

**LLM Call testen (ohne Container zu öffnen):**

```bash
docker run --rm -v oc-1-data:/root/.local/share/opencode oc run "say hello" --format json --print-logs 2>&1 | grep '"text"'
```

---

## Was ist im Image?

- **OpenCode CLI** v1.3.17 (native musl binary)
- **GitHub CLI** v2.83.0
- **oh-my-opencode** v3.11.2 → Subagenten: explore, librarian, etc.
- **opencode-antigravity-auth** v1.6.5-beta.0
- **opencode.json** mit qwen3.6-plus-free als Standardmodell

## Warum so und nicht anders

**FALSCH:**
- `npm install -g opencode-ai` im Docker → installiert macOS Binary, nicht Linux
- Selbes Volume für alle Container → **selbe machine-id** → **shared rate limit**

**RICHTIG:**
- **Native Binary direkt von GitHub Releases**
- **Alpine Linux** → musl libc, passt zum Binary
- **Jeder Container = EIGENES Docker Volume** → eigene Identität
- **Kurze Namen:** `oc-1`, `oc-2`, `oc-3` ...

## Architektur

```
┌──────────────────────────────┐
│        Image: oc              │
│  Alpine + Binary + Plugins    │
│  ~87MB                        │
└──────────────────────────────┘
       │            │            │
       ▼            ▼            ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│ oc-1     │  │ oc-2     │  │ oc-3     │
│ Volume   │  │ Volume   │  │ Volume   │
│ ID: A    │  │ ID: B    │  │ ID: C    │
└──────────┘  └──────────┘  └──────────┘
   Rate Limit    Rate Limit    Rate Limit
   (eigen!)      (eigen!)      (eigen!)
```

## Cleanup

```bash
docker rm -f $(docker ps -aq --filter "name=oc-") 2>/dev/null
docker volume prune -f
docker rmi oc 2>/dev/null
```
