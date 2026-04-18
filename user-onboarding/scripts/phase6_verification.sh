#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $*"; }
fail() { echo -e "${RED}[✗]${NC} $*"; FAILURES=$((FAILURES+1)); }
info() { echo -e "${BLUE}[→]${NC} $*"; }

FAILURES=0
GCLOUD=$(cat /tmp/opensin-gcloud-path 2>/dev/null || echo "gcloud")
PM_CLI="$HOME/.config/sin/sin-passwordmanager/build/dist/src/cli.js"

info "Running verification checks..."
echo ""

info "1. gcloud authentication"
SA_ACTIVE=$($GCLOUD auth list --format="value(account)" --filter="status:ACTIVE" 2>/dev/null || true)
if [ -n "$SA_ACTIVE" ]; then
  log "Active account: $SA_ACTIVE"
else
  fail "No active gcloud account"
fi

info "2. Google Cloud Secrets access"
if $GCLOUD secrets list --project="$(cat /tmp/opensin-gcp-project 2>/dev/null || $GCLOUD config get-value project 2>/dev/null)" --format="value(name)" 2>/dev/null; then
  log "Secret Manager access verified"
else
  fail "Cannot access Secret Manager"
fi

info "3. Passwordmanager health"
if [ -f "$PM_CLI" ]; then
  HEALTH=$(SPM_SECRET_BACKEND=gcloud node "$PM_CLI" run-action '{"action":"sin.passwordmanager.health"}' 2>/dev/null || echo '{}')
  if echo "$HEALTH" | python3 -c "import sys,json; d=json.load(sys.stdin); assert d.get('ok')" 2>/dev/null; then
    log "Passwordmanager healthy (backend: gcloud)"
  else
    fail "Passwordmanager health check returned not-ok"
  fi
else
  fail "Passwordmanager CLI not found at $PM_CLI"
fi

info "4. spm CLI"
if [ -x "$HOME/.local/bin/spm" ]; then
  log "spm CLI installed at ~/.local/bin/spm"
else
  fail "spm CLI not found at ~/.local/bin/spm"
fi

info "5. OpenSIN Bridge extension"
EXT_DIR="$HOME/.config/sin/opensin-bridge"
if [ -f "$EXT_DIR/manifest.json" ]; then
  EXT_VER=$(python3 -c "import json; print(json.load(open('$EXT_DIR/manifest.json'))['version'])" 2>/dev/null || echo "?")
  log "OpenSIN Bridge v$EXT_VER files present"
else
  fail "OpenSIN Bridge not found at $EXT_DIR"
fi

info "6. Service account key"
KEY_FILE="$HOME/.config/opencode/auth/google/service-account.json"
if [ -f "$KEY_FILE" ]; then
  KEY_PERMS=$(stat -f "%Lp" "$KEY_FILE" 2>/dev/null || stat -c "%a" "$KEY_FILE" 2>/dev/null || echo "???")
  log "SA key exists (permissions: $KEY_PERMS)"
else
  fail "SA key file not found at $KEY_FILE"
fi

echo ""
echo "═══════════════════════════════════════"
if [ "$FAILURES" -eq 0 ]; then
  log "All checks passed! OpenSIN is ready."
else
  fail "$FAILURES check(s) failed — review output above"
fi
echo "═══════════════════════════════════════"
