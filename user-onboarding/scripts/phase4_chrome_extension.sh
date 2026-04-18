#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }
info() { echo -e "${BLUE}[→]${NC} $*"; }

EXT_REPO="https://github.com/OpenSIN-AI/OpenSIN-backend.git"
EXT_SRC_RELATIVE="services/sin-chrome-extension/extension"
EXT_DIR="$HOME/.config/sin/opensin-bridge"
CHROME_APP="/Applications/Google Chrome.app"

if [ -d "$EXT_DIR/background" ] && [ -f "$EXT_DIR/manifest.json" ]; then
  log "OpenSIN Bridge already exists at $EXT_DIR"
else
  info "Cloning OpenSIN Bridge extension source..."
  TEMP_CLONE=$(mktemp -d)
  git clone --depth=1 --filter=blob:none --sparse "$EXT_REPO" "$TEMP_CLONE" 2>&1 | tail -1
  cd "$TEMP_CLONE"
  git sparse-checkout set "$EXT_SRC_RELATIVE" 2>&1
  
  mkdir -p "$EXT_DIR"
  cp -r "$TEMP_CLONE/$EXT_SRC_RELATIVE/"* "$EXT_DIR/"
  rm -rf "$TEMP_CLONE"
  log "Extension files copied to $EXT_DIR"
fi

EXT_VER=$(python3 -c "import json; print(json.load(open('$EXT_DIR/manifest.json'))['version'])" 2>/dev/null || echo "unknown")
log "OpenSIN Bridge version: $EXT_VER"

info "To load the extension in Chrome:"
echo ""
echo "  Option A (Recommended — Automatic):"
echo "    1. Open Chrome and go to: chrome://extensions"
echo "    2. Enable 'Developer mode' (top right toggle)"
echo "    3. Click 'Load unpacked' and select: $EXT_DIR"
echo ""
echo "  Option B (CLI — requires Chrome restart):"
echo "    Close Chrome, then run:"
echo "    /Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome \\"
echo "      --load-extension=\"$EXT_DIR\" \\"
echo "      --remote-debugging-port=9335"
echo ""

if pgrep -f "Google Chrome" &>/dev/null; then
  CDP_PORT=""
  for port in 9335 9334 9222; do
    if curl -s "http://localhost:$port/json/version" &>/dev/null; then
      CDP_PORT=$port
      break
    fi
  done
  
  if [ -n "$CDP_PORT" ]; then
    info "Chrome detected with CDP on port $CDP_PORT"
    
    EXTENSIONS_LOADED=$(curl -s "http://localhost:$CDP_PORT/json" 2>/dev/null | python3 -c "
import sys, json
tabs = json.load(sys.stdin)
ext_tabs = [t for t in tabs if 'opensin' in t.get('title','').lower() or 'opensin' in t.get('url','').lower()]
print(len(ext_tabs))
" 2>/dev/null || echo "0")
    
    if [ "$EXTENSIONS_LOADED" != "0" ]; then
      log "OpenSIN Bridge appears to be active in Chrome"
    else
      warn "OpenSIN Bridge not detected in running Chrome — load it manually via chrome://extensions"
    fi
  else
    warn "Chrome running but no CDP port found — extension status unknown"
  fi
else
  info "Chrome not running — extension will be loaded on next Chrome start"
fi

log "Phase 4 complete — OpenSIN Bridge extension ready at $EXT_DIR"
