# OpenSIN Onboarding

> [!IMPORTANT]
> **SSOT:** Die kanonische OpenCode-Konfiguration liegt unter [Delqhi/upgraded-opencode-stack](https://github.com/Delqhi/upgraded-opencode-stack).
> Nach jeder Änderung MUSS `sin-sync` ausgeführt werden.

**Autonomous first-run setup for OpenSIN — zero manual intervention.**

When a new user runs OpenSIN for the first time, this onboarding system automatically:

1. **Installs & configures the A2A-SIN-Passwordmanager** with Google Cloud Secrets backend
2. **Installs OpenSIN Bridge** Chrome Extension via CLI sideload
3. **Registers API accounts** on free-tier platforms (NVIDIA NIM, Groq, Hugging Face, etc.)
4. **Provisions gcloud service account** for secrets management
5. **Seeds initial credentials** into the Passwordmanager vault

## Architecture

```
User runs: opensin init
            │
            ▼
┌─────────────────────────────┐
│  Phase 0: Bun Install ⚡   │
│  ─ brew install oven-sh/bun/bun │
│  ─ NEVER npm or npx!       │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  Phase 1: System Bootstrap  │
│  ─ gcloud CLI install       │
│  ─ Bun verify (NOT npm!)    │
│  ─ Chrome verify             │
│  ─ opencode CLI verify       │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  Phase 2: GCP Project Setup │
│  ─ gcloud auth login (CDP)  │
│  ─ Create GCP project       │
│  ─ Enable Secret Manager API│
│  ─ Create service account   │
│  ─ Generate & store SA key  │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  Phase 3: Passwordmanager   │
│  ─ Build from source        │
│  ─ Configure gcloud backend │
│  ─ Verify health check      │
│  ─ Symlink CLI (spm)        │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  Phase 4: Chrome Extension  │
│  ─ Build extension           │
│  ─ Sideload via chrome CLI  │
│  ─ Verify extension active  │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  Phase 5: Platform Accounts │
│  ─ Groq (free vision API)   │
│  ─ NVIDIA NIM (free tier)   │
│  ─ Hugging Face (spaces)    │
│  ─ Store all keys in PM     │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  Phase 5.5: Cloud Storage    │
│  ─ Box.com account creation │
│  ─ Create Public/Cache folders │
│  ─ Enable sharing (public links)│
│  ─ Optional: Developer Token │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  Phase 6: Verification      │
│  ─ PM health check          │
│  ─ gcloud secrets list      │
│  ─ Extension ping           │
│  ─ API key validation       │
│  ─ Print onboarding report  │
└─────────────────────────────┘
```

## Cloud Storage Integration

OpenSIN uses **Box.com** (10 GB free) as primary cloud storage, replacing GitLab Storage (account banned).

### Storage Layout

| Folder | Purpose | Sharing |
|--------|---------|---------|
| `/OpenSIN-Public` | Logos, images, docs (publicly accessible) | "People with link" → Can view |
| `/OpenSIN-Cache` | Logs, cache, temporary files | "People with link" → Can view |

### User Onboarding Flow

During `opensin init`, users are guided through:

1. **Create Box.com account** (free 10 GB)
2. **Create folders** `/OpenSIN-Public` and `/OpenSIN-Cache`
3. **Enable sharing** (public links must work, otherwise 404!)
4. **Optional:** Create Box Developer Token for API access

### Important Notes

- **GitLab Storage is DEAD** — all previous GitLab-based log/cache uploads are migrated to Box.com
- **Public links must be enabled** — without "People with the link" sharing, URLs return 404
- **Developer Token** (optional) allows programmatic uploads via Box API
- **Alternative:** Google Drive (15 GB free) can be used instead for user data

### Configuration

After onboarding, users should:

1. Get folder IDs from Box.com (`box folders:children 0`)
2. Add to `.env`:
   ```bash
   BOX_PUBLIC_FOLDER_ID=<id>
   BOX_CACHE_FOLDER_ID=<id>
   BOX_DEVELOPER_TOKEN=<token>
   ```
3. Share the public links with the OpenSIN team

### Default Public Links (Example)

- Public: https://app.box.com/s/1st624o9eb5xdistusew5w0erb8offc7
- Cache: https://app.box.com/s/9s5htoefw1ux9ajaqj656v9a02h7z7x1

**⚠️ These links only work if sharing is properly configured!**

## Quick Start

```bash
git clone https://github.com/OpenSIN-AI/OpenSIN-onboarding.git
cd OpenSIN-onboarding
./scripts/onboard.sh
```

Or via OpenSIN CLI:

```bash
opensin init
```

## Directory Structure

```
OpenSIN-onboarding/
├── scripts/
│   ├── onboard.sh                  # Main entry point
│   ├── phase1_system_bootstrap.sh  # System prerequisites
│   ├── phase2_gcp_setup.sh         # GCP project + service account
│   ├── phase3_passwordmanager.sh   # PM build + configure
│   ├── phase4_chrome_extension.sh  # Extension sideload
│   ├── phase5_platform_accounts.py # Autonomous account registration
│   └── phase6_verification.sh      # End-to-end health checks
├── docs/
│   ├── 01-prerequisites.md         # What users need before starting
│   ├── 02-passwordmanager-setup.md # Deep dive: PM + GCS architecture
│   ├── 03-chrome-extension.md      # Extension installation details
│   ├── 04-platform-accounts.md     # Platform registration reference
│   ├── 05-troubleshooting.md       # Common issues + fixes
│   └── 06-security-model.md        # How secrets are protected
├── config/
│   └── templates/
│       ├── catalog.template.json   # PM catalog seed template
│       └── env.template            # Environment variable template
├── .well-known/
│   └── agent-card.json             # A2A discovery card
└── README.md
```

## Supported Platforms (Auto-Registration)

| Platform | Free Tier | What OpenSIN Uses It For |
|----------|-----------|--------------------------|
| **Google Cloud** | $300 credit + always-free Secret Manager (6 active versions) | Passwordmanager backend (Google Cloud Secrets) |
| **Groq** | 14,400 req/day (vision models) | OpenSIN Bridge vision analysis |
| **NVIDIA NIM** | 1,000 free API calls/month | Specialized AI models (Qwen, Cosmos) |
| **Hugging Face** | Unlimited free CPU Spaces | A2A agent hosting |
| **GitHub** | Unlimited public repos | Code hosting, Issues, A2A coordination |

## How Autonomous Registration Works

OpenSIN uses the **Two-Layer Browser Stack** (nodriver + CDP) to:

1. Navigate to platform signup page
2. Fill registration forms with user-provided email
3. Handle email verification via user's mail client
4. Extract API keys from dashboard
5. Store keys in Passwordmanager (Google Cloud Secrets)

The user only needs to provide:
- **Email address** (for account registration)
- **Google account** (for GCP + Chrome profile)

Everything else is fully autonomous.

## Security Model

- All secrets stored in **Google Cloud Secret Manager** (encrypted at rest with Google-managed keys)
- Service account key stored locally at `~/.config/opencode/auth/google/` with `600` permissions
- No secrets ever committed to git (enforced by `.gitignore` + pre-commit hooks)
- Secret names follow pattern: `spm-{name}` in GCP
- Passwordmanager catalog (metadata only, no values) at `~/.config/sin/sin-passwordmanager/catalog.json`

## Related Repositories

| Repository | Purpose |
|-----------|---------|
| [OpenSIN-backend](https://github.com/OpenSIN-AI/OpenSIN-backend) | A2A-SIN-Passwordmanager source code |
| [OpenSIN-documentation](https://github.com/OpenSIN-AI/OpenSIN-documentation) | Full platform docs (docs.opensin.ai) |
| [OpenSIN-overview](https://github.com/OpenSIN-AI/OpenSIN-overview) | Organization SSOT registry |
| [OpenSIN](https://github.com/OpenSIN-AI/OpenSIN) | Core platform |
| [OpenSIN-Code](https://github.com/OpenSIN-AI/OpenSIN-Code) | CLI tool |

## License

Apache 2.0 — see [LICENSE](LICENSE)
