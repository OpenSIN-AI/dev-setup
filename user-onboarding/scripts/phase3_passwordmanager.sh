#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }
info() { echo -e "${BLUE}[→]${NC} $*"; }

PM_REPO="https://github.com/OpenSIN-AI/OpenSIN-backend.git"
PM_DIR="$HOME/.config/sin/sin-passwordmanager"
PM_SRC_RELATIVE="a2a/team-infrastructure/A2A-SIN-Passwordmanager"
PM_BUILD_DIR="$PM_DIR/build"
SPM_BIN="$HOME/.local/bin/spm"

mkdir -p "$PM_DIR" "$HOME/.local/bin"

if [ -d "$PM_BUILD_DIR/src" ] && [ -f "$PM_BUILD_DIR/dist/src/cli.js" ]; then
  log "Passwordmanager already built at $PM_BUILD_DIR"
else
  info "Cloning Passwordmanager source (sparse checkout)..."
  TEMP_CLONE=$(mktemp -d)
  git clone --depth=1 --filter=blob:none --sparse "$PM_REPO" "$TEMP_CLONE" 2>&1 | tail -1
  cd "$TEMP_CLONE"
  git sparse-checkout set "$PM_SRC_RELATIVE" 2>&1
  
  cp -r "$TEMP_CLONE/$PM_SRC_RELATIVE" "$PM_BUILD_DIR"
  rm -rf "$TEMP_CLONE"
  
  info "Installing dependencies..."
  cd "$PM_BUILD_DIR"
  npm install --production=false 2>&1 | tail -3
  
  info "Building TypeScript..."
  npx tsc 2>&1 || npm run build 2>&1 | tail -3
  log "Passwordmanager built successfully"
fi

cat > "$SPM_BIN" << 'SPMEOF'
#!/usr/bin/env bash
export SPM_SECRET_BACKEND="${SPM_SECRET_BACKEND:-gcloud}"
PM_CLI="$HOME/.config/sin/sin-passwordmanager/build/dist/src/cli.js"
exec node "$PM_CLI" "$@"
SPMEOF
chmod +x "$SPM_BIN"
log "CLI symlink created: $SPM_BIN"

cat > "$PM_DIR/backend.env" << ENVEOF
SPM_SECRET_BACKEND=gcloud
SPM_GCLOUD_PROJECT=$(cat /tmp/opensin-gcp-project 2>/dev/null || echo "artificial-biometrics")
ENVEOF

if [ ! -f "$PM_DIR/catalog.json" ]; then
  echo '{"secrets":[],"version":1}' > "$PM_DIR/catalog.json"
  log "Empty catalog created"
fi

info "Verifying Passwordmanager health..."
HEALTH=$(SPM_SECRET_BACKEND=gcloud node "$PM_BUILD_DIR/dist/src/cli.js" run-action '{"action":"sin.passwordmanager.health"}' 2>&1)
if echo "$HEALTH" | python3 -c "import sys,json; d=json.load(sys.stdin); assert d['ok']; print(f'  backend: {d[\"backend\"]}'); print(f'  actionsReady: {d[\"actionsReady\"]}')" 2>/dev/null; then
  log "Passwordmanager health check passed"
else
  err "Passwordmanager health check failed:\n$HEALTH"
fi

log "Phase 3 complete — Passwordmanager ready with gcloud backend"
