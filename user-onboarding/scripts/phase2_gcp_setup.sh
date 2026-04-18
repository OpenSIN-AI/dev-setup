#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; exit 1; }
info() { echo -e "${BLUE}[→]${NC} $*"; }

GCLOUD=$(cat /tmp/opensin-gcloud-path 2>/dev/null || echo "gcloud")
GCP_PROJECT="opensin-$(whoami | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9' | head -c 12)-$(date +%s | tail -c 5)"
SA_EMAIL="opensin-agent@${GCP_PROJECT}.iam.gserviceaccount.com"
KEY_DIR="$HOME/.config/opencode/auth/google"
KEY_FILE="$KEY_DIR/service-account.json"

mkdir -p "$KEY_DIR"

ACTIVE=$($GCLOUD auth list --format="value(account)" --filter="status:ACTIVE" 2>/dev/null || true)
if [ -z "$ACTIVE" ]; then
  info "No gcloud account active — starting browser-based OAuth login..."

  if command -v python3 &>/dev/null && python3 -c "import websockets" 2>/dev/null; then
    OAUTH_OUTPUT=$($GCLOUD auth login --no-launch-browser 2>&1 &
      GCLOUD_PID=$!
      sleep 3
      kill $GCLOUD_PID 2>/dev/null || true
      wait $GCLOUD_PID 2>/dev/null || true
    )
    warn "Automatic CDP login requires Chrome with --remote-debugging-port."
    warn "Falling back to interactive login..."
  fi

  $GCLOUD auth login --project="$GCP_PROJECT" --brief 2>&1 || err "gcloud auth login failed"
fi

ACTIVE=$($GCLOUD auth list --format="value(account)" --filter="status:ACTIVE" 2>/dev/null)
log "Authenticated as: $ACTIVE"

EXISTING_PROJECT=$($GCLOUD config get-value project 2>/dev/null || true)
if [ -n "$EXISTING_PROJECT" ] && [ "$EXISTING_PROJECT" != "(unset)" ]; then
  info "Using existing GCP project: $EXISTING_PROJECT"
  GCP_PROJECT="$EXISTING_PROJECT"
  SA_EMAIL="opensin-agent@${GCP_PROJECT}.iam.gserviceaccount.com"
else
  info "Creating GCP project: $GCP_PROJECT"
  $GCLOUD projects create "$GCP_PROJECT" --name="OpenSIN Onboarding" 2>&1 || {
    warn "Project creation failed (may need billing). Using default project."
    GCP_PROJECT=$($GCLOUD config get-value project 2>/dev/null)
    SA_EMAIL="opensin-agent@${GCP_PROJECT}.iam.gserviceaccount.com"
  }
  $GCLOUD config set project "$GCP_PROJECT" 2>/dev/null
fi

log "GCP Project: $GCP_PROJECT"

info "Enabling Secret Manager API..."
$GCLOUD services enable secretmanager.googleapis.com --project="$GCP_PROJECT" 2>&1 || warn "API enable failed (may already be enabled)"
log "Secret Manager API enabled"

EXISTING_SA=$($GCLOUD iam service-accounts list --project="$GCP_PROJECT" --format="value(email)" --filter="email:opensin-agent" 2>/dev/null || true)
if [ -n "$EXISTING_SA" ]; then
  log "Service account exists: $EXISTING_SA"
  SA_EMAIL="$EXISTING_SA"
else
  info "Creating service account: opensin-agent"
  $GCLOUD iam service-accounts create opensin-agent \
    --display-name="OpenSIN Agent" \
    --description="Service account for OpenSIN Passwordmanager and A2A agents" \
    --project="$GCP_PROJECT" 2>&1
  log "Service account created: $SA_EMAIL"
fi

info "Granting Secret Manager Admin role..."
$GCLOUD projects add-iam-policy-binding "$GCP_PROJECT" \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/secretmanager.admin" \
  --condition=None \
  --quiet 2>&1 | tail -1
log "IAM role granted"

if [ -f "$KEY_FILE" ]; then
  info "Existing key file found, testing validity..."
  if $GCLOUD auth activate-service-account "$SA_EMAIL" --key-file="$KEY_FILE" --project="$GCP_PROJECT" 2>/dev/null; then
    log "Existing key is valid"
  else
    warn "Existing key is stale, generating new one..."
    mv "$KEY_FILE" "${KEY_FILE}.stale.$(date +%s).bak"
    $GCLOUD iam service-accounts keys create "$KEY_FILE" \
      --iam-account="$SA_EMAIL" --project="$GCP_PROJECT" --key-file-type=json 2>&1
    $GCLOUD auth activate-service-account "$SA_EMAIL" --key-file="$KEY_FILE" --project="$GCP_PROJECT" 2>&1
    log "New key generated and activated"
  fi
else
  info "Generating service account key..."
  $GCLOUD iam service-accounts keys create "$KEY_FILE" \
    --iam-account="$SA_EMAIL" --project="$GCP_PROJECT" --key-file-type=json 2>&1
  $GCLOUD auth activate-service-account "$SA_EMAIL" --key-file="$KEY_FILE" --project="$GCP_PROJECT" 2>&1
  log "Key generated and activated"
fi

chmod 600 "$KEY_FILE"

cp "$KEY_FILE" "$HOME/.config/google/service_account.json" 2>/dev/null || true

python3 -c "
import json
with open('$KEY_FILE') as f: k = json.load(f)
print(f'  project_id:     {k[\"project_id\"]}')
print(f'  client_email:   {k[\"client_email\"]}')
print(f'  private_key_id: {k[\"private_key_id\"][:16]}...')
"

echo "$GCP_PROJECT" > /tmp/opensin-gcp-project
echo "$SA_EMAIL" > /tmp/opensin-sa-email

$GCLOUD secrets list --project="$GCP_PROJECT" --format="value(name)" 2>/dev/null | head -5 || true

log "Phase 2 complete — GCP project and service account ready"
