# Passwordmanager + Google Cloud Secrets Setup

The **A2A-SIN-Passwordmanager** is the central secrets authority for the entire OpenSIN ecosystem. Every agent, extension, and service retrieves credentials through it.

## Architecture

```
┌──────────────────────┐
│   A2A Agent / CLI    │
│   "spm run-action"   │
└──────────┬───────────┘
           │ JSON-RPC
           ▼
┌──────────────────────┐
│  SIN-Passwordmanager │
│  (Node.js runtime)   │
│                      │
│  Backends:           │
│  ├── gcloud (default)│ ──→ Google Cloud Secret Manager
│  ├── keychain        │ ──→ macOS Keychain
│  └── file            │ ──→ AES-256-GCM encrypted file
└──────────────────────┘
```

## Backend: Google Cloud Secrets (Default)

The `gcloud` backend stores each secret as a Google Cloud Secret Manager resource:

- **Secret naming**: `spm-{name}` (e.g., `GROQ_API_KEY_1` → `spm-groq_api_key_1`)
- **Encryption**: Google-managed AES-256 at rest
- **Replication**: Automatic (multi-region)
- **Free tier**: 6 active secret versions, 10,000 access operations/month
- **Project**: User's own GCP project (created during onboarding)

### Service Account

The Passwordmanager authenticates via a GCP service account:

| Field | Value |
|-------|-------|
| **Account** | `opensin-agent@{project}.iam.gserviceaccount.com` |
| **Role** | `roles/secretmanager.admin` |
| **Key file** | `~/.config/opencode/auth/google/service-account.json` |
| **Permissions** | `600` (owner read/write only) |

### Key Rotation

If the service account key is compromised or expired:

```bash
GCLOUD=/opt/homebrew/Caskroom/gcloud-cli/*/google-cloud-sdk/bin/gcloud

# 1. Authenticate as user (not SA)
$GCLOUD auth login --no-launch-browser

# 2. Create new key
$GCLOUD iam service-accounts keys create /tmp/new-key.json \
  --iam-account=opensin-agent@YOUR_PROJECT.iam.gserviceaccount.com

# 3. Install and activate
cp /tmp/new-key.json ~/.config/opencode/auth/google/service-account.json
chmod 600 ~/.config/opencode/auth/google/service-account.json
$GCLOUD auth activate-service-account --key-file=~/.config/opencode/auth/google/service-account.json

# 4. Verify
$GCLOUD secrets list --project=YOUR_PROJECT

# 5. Clean up
rm /tmp/new-key.json
```

## CLI Usage

```bash
export SPM_SECRET_BACKEND=gcloud

# Health check
spm run-action '{"action":"sin.passwordmanager.health"}'

# Store a secret
spm run-action '{"action":"sin.passwordmanager.secret.put","name":"MY_KEY","value":"sk-...","description":"My API key","tags":["auth"]}'

# Retrieve (masked)
spm run-action '{"action":"sin.passwordmanager.secret.get","name":"MY_KEY"}'

# Retrieve (revealed)
spm run-action '{"action":"sin.passwordmanager.secret.get","name":"MY_KEY","reveal":true}'

# List all secrets
spm run-action '{"action":"sin.passwordmanager.secret.list"}'

# Delete
spm run-action '{"action":"sin.passwordmanager.secret.delete","name":"MY_KEY"}'
```

## Catalog

The catalog at `~/.config/sin/sin-passwordmanager/catalog.json` stores **metadata only** (names, descriptions, tags, targets). Secret **values** are never stored locally — they live exclusively in Google Cloud Secret Manager.

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `Invalid JWT Signature` | SA key was rotated/revoked on Google's side | Follow key rotation steps above |
| `PERMISSION_DENIED` | SA lacks `secretmanager.admin` role | Re-run `gcloud projects add-iam-policy-binding` |
| `Secret not found` | Secret doesn't exist in GCP | Create with `secret.put` action |
| `undefined` output | Wrong action name (e.g., `set` instead of `secret.put`) | Use full action name: `sin.passwordmanager.secret.put` |
