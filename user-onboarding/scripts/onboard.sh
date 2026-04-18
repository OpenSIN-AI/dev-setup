#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; }
info() { echo -e "${BLUE}[→]${NC} $*"; }

ONBOARD_STATE="$HOME/.config/sin/onboarding-state.json"

save_state() {
  local phase="$1" status="$2"
  mkdir -p "$(dirname "$ONBOARD_STATE")"
  python3 -c "
import json, os, datetime
path = '$ONBOARD_STATE'
state = {}
if os.path.exists(path):
    with open(path) as f: state = json.load(f)
state['$phase'] = {'status': '$status', 'timestamp': datetime.datetime.utcnow().isoformat() + 'Z'}
with open(path, 'w') as f: json.dump(state, f, indent=2)
"
}

check_phase_done() {
  local phase="$1"
  if [ -f "$ONBOARD_STATE" ]; then
    python3 -c "
import json, sys
with open('$ONBOARD_STATE') as f: state = json.load(f)
sys.exit(0 if state.get('$phase', {}).get('status') == 'completed' else 1)
" 2>/dev/null && return 0
  fi
  return 1
}

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            OpenSIN — Autonomous Onboarding v1.0            ║"
echo "║        Zero manual intervention. Fully autonomous.         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

if check_phase_done "phase1"; then
  log "Phase 1 already completed, skipping..."
else
  info "Phase 1: System Bootstrap"
  bash "$SCRIPT_DIR/phase1_system_bootstrap.sh"
  save_state "phase1" "completed"
fi

if check_phase_done "phase2"; then
  log "Phase 2 already completed, skipping..."
else
  info "Phase 2: GCP Project + Service Account"
  bash "$SCRIPT_DIR/phase2_gcp_setup.sh"
  save_state "phase2" "completed"
fi

if check_phase_done "phase3"; then
  log "Phase 3 already completed, skipping..."
else
  info "Phase 3: Passwordmanager Setup"
  bash "$SCRIPT_DIR/phase3_passwordmanager.sh"
  save_state "phase3" "completed"
fi

if check_phase_done "phase4"; then
  log "Phase 4 already completed, skipping..."
else
  info "Phase 4: Chrome Extension Install"
  bash "$SCRIPT_DIR/phase4_chrome_extension.sh"
  save_state "phase4" "completed"
fi

if check_phase_done "phase5"; then
  log "Phase 5 already completed, skipping..."
else
  info "Phase 5: Platform Account Registration"
  python3 "$SCRIPT_DIR/phase5_platform_accounts.py"
  save_state "phase5" "completed"
fi

if check_phase_done "phase5_storage"; then
  log "Phase 5.5 already completed, skipping..."
else
  info "Phase 5.5: Cloud Storage Setup"
  bash "$SCRIPT_DIR/phase5_storage_setup.sh"
  save_state "phase5_storage" "completed"
fi

info "Phase 6: Verification"
bash "$SCRIPT_DIR/phase6_verification.sh"
save_state "phase6" "completed"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              ✅ OpenSIN Onboarding Complete!                ║"
echo "║                                                            ║"
echo "║  Passwordmanager:  gcloud backend active                   ║"
echo "║  Chrome Extension: OpenSIN Bridge installed                ║"
echo "║  Platform Keys:    Stored in Google Cloud Secrets          ║"
echo "║                                                            ║"
echo "║  Run 'opensin status' to verify your setup anytime.        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
