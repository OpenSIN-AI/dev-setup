# OpenCode Setup für Partner-Entwickler

Diese Anleitung gilt für unseren Fork `Delqhi/sin-opencode`.

Kurz gesagt: **OpenCode normal installieren, dann unsere SSOT-Konfiguration aus dem Fork ziehen.**

## 1. Repo holen

```bash
git clone git@github.com:Delqhi/sin-opencode.git
cd sin-opencode
```

Wenn das Repo schon da ist:

```bash
git pull
```

## 2. Globale Konfiguration synchronisieren

```bash
sin-sync
```

Das kopiert die globale OpenCode-Konfiguration auf deinen Mac nach `~/.config/opencode`.

## 3. OpenCode starten

```bash
opencode
```

Oder zum schnellen Test:

```bash
opencode run "echo ok"
opencode --version
```

## 4. Was im Fork drin ist

- `global-opencode-config/` als SSOT
- `opencode.json`
- `mcp.json`
- `plugins/`
- `skills/`
- `scripts/`
- `tools/`
- `hooks/`

## 5. Was absichtlich lokal bleibt

Diese Dinge gehören **nicht** in Git:

- Auth-Dateien
- Token-Dateien
- Datenbanken
- Logs
- Chrome-Profile

## 6. Wenn du etwas änderst

1. Datei in `~/.config/opencode` ändern.
2. `sin-sync` ausführen.
3. Dann erst Commit oder PR machen.

So bleibt dein Rechner mit dem Fork identisch.

## 7. Wichtige Links

- Fork: `https://github.com/Delqhi/sin-opencode`
- SSOT-Konfig: `global-opencode-config/`
- Partner-Doku: `README.md`
