# Security Model

## Secrets Storage

All secrets are stored in **Google Cloud Secret Manager** (GCS):

| Property | Value |
|----------|-------|
| **Encryption at rest** | AES-256 (Google-managed keys) |
| **Encryption in transit** | TLS 1.3 |
| **Replication** | Automatic multi-region |
| **Access control** | IAM-based (service account with `secretmanager.admin`) |
| **Audit logging** | Cloud Audit Logs (data access + admin activity) |

## Local Files

| File | Contents | Permissions |
|------|----------|-------------|
| `~/.config/opencode/auth/google/service-account.json` | SA private key (most sensitive) | `600` |
| `~/.config/sin/sin-passwordmanager/catalog.json` | Secret metadata (names, tags — no values) | `644` |
| `~/.config/sin/onboarding-state.json` | Phase completion timestamps | `644` |

## What Is Never Stored Locally

- Secret **values** (only in GCS)
- OAuth refresh tokens (handled by gcloud CLI)
- Platform passwords (only API keys stored)

## Git Safety

The following patterns are excluded from all OpenSIN repos:

```gitignore
*.json.bak
**/auth/google/*.json
**/service_account.json
**/.env
**/.env.local
**/token.json
**/credentials.db
```

## Service Account Key Lifecycle

1. **Created** during onboarding (Phase 2)
2. **Stored** at `~/.config/opencode/auth/google/service-account.json` with `600` permissions
3. **Never committed** to any git repository
4. **Rotated** when compromised using `gcloud iam service-accounts keys create`
5. **Old keys** are renamed to `.stale.TIMESTAMP.bak` and should be deleted after verification

## Threat Model

| Threat | Mitigation |
|--------|-----------|
| Key committed to public repo | Google auto-disables exposed keys; rotation procedure documented |
| Local machine compromised | Key file has `600` permissions; values only in GCS |
| GCS compromised | Google's infrastructure security; IAM access controls |
| Man-in-the-middle | TLS 1.3 for all GCS API calls |
| Unauthorized agent access | Each agent authenticates via the same SA; future: per-agent SA |
