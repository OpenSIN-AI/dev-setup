#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }
info() { echo -e "${BLUE}[→]${NC} $*"; }

info "Checking system prerequisites..."

# Node.js
if command -v node &>/dev/null; then
  NODE_VER=$(node --version)
  log "Node.js: $NODE_VER"
  NODE_MAJOR=$(echo "$NODE_VER" | sed 's/v//' | cut -d. -f1)
  [ "$NODE_MAJOR" -lt 18 ] && err "Node.js 18+ required (found $NODE_VER). Install via: brew install node"
else
  err "Node.js not found. Install via: brew install node"
fi

# npm
command -v npm &>/dev/null && log "npm: $(npm --version)" || err "npm not found"

# Python 3
if command -v python3 &>/dev/null; then
  log "Python3: $(python3 --version)"
else
  err "Python3 not found. Install via: brew install python3"
fi

# Git
command -v git &>/dev/null && log "Git: $(git --version | cut -d' ' -f3)" || err "Git not found"

# gh CLI
command -v gh &>/dev/null && log "GitHub CLI: $(gh --version | head -1 | awk '{print $3}')" || err "GitHub CLI not found. Install via: brew install gh"

# Chrome
CHROME_APP="/Applications/Google Chrome.app"
if [ -d "$CHROME_APP" ]; then
  CHROME_VER=$("$CHROME_APP/Contents/MacOS/Google Chrome" --version 2>/dev/null | awk '{print $NF}')
  log "Chrome: $CHROME_VER"
else
  err "Google Chrome not found at $CHROME_APP"
fi

# gcloud CLI
GCLOUD_PATHS=(
  "/opt/homebrew/Caskroom/gcloud-cli/*/google-cloud-sdk/bin/gcloud"
  "/usr/local/Caskroom/gcloud-cli/*/google-cloud-sdk/bin/gcloud"
  "$HOME/google-cloud-sdk/bin/gcloud"
)
GCLOUD=""
for pattern in "${GCLOUD_PATHS[@]}"; do
  for match in $pattern; do
    [ -x "$match" ] && GCLOUD="$match" && break 2
  done
done

if [ -n "$GCLOUD" ]; then
  log "gcloud CLI: $($GCLOUD --version 2>/dev/null | head -1 | awk '{print $4}')"
else
  info "gcloud CLI not found — installing via Homebrew..."
  if command -v brew &>/dev/null; then
    brew install --cask google-cloud-sdk
    GCLOUD="/opt/homebrew/Caskroom/gcloud-cli/$(ls /opt/homebrew/Caskroom/gcloud-cli/ | head -1)/google-cloud-sdk/bin/gcloud"
    log "gcloud CLI installed: $($GCLOUD --version 2>/dev/null | head -1 | awk '{print $4}')"
  else
    err "Neither gcloud nor Homebrew found. Install gcloud manually: https://cloud.google.com/sdk/docs/install"
  fi
fi

echo "$GCLOUD" > /tmp/opensin-gcloud-path
mkdir -p "$HOME/.config/sin"

log "Phase 1 complete — all system prerequisites satisfied"
