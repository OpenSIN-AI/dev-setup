# Platform Account Registration

OpenSIN autonomously registers accounts on free-tier AI platforms so you don't have to. This document covers each platform and what OpenSIN uses it for.

## Registration Flow

```
User provides: email + Google account
         │
         ▼
OpenSIN Browser Automation (CDP + nodriver)
         │
         ├── Navigate to signup page
         ├── Fill registration form
         ├── Handle email verification
         ├── Extract API key from dashboard
         └── Store key in Passwordmanager (GCS)
```

## Supported Platforms

### Groq

| Field | Value |
|-------|-------|
| **URL** | [console.groq.com](https://console.groq.com) |
| **Free Tier** | 14,400 requests/day (vision models) |
| **Used For** | OpenSIN Bridge vision analysis (llama-3.2-11b-vision, llama-4-scout) |
| **PM Key Name** | `GROQ_API_KEY` |
| **Signup** | Email + password, email verification |

**Why Groq?** Groq provides the highest free-tier rate limit for vision models — 14,400 requests/day is enough for continuous agent operation without hitting limits.

### NVIDIA NIM

| Field | Value |
|-------|-------|
| **URL** | [build.nvidia.com](https://build.nvidia.com) |
| **Free Tier** | 1,000 API calls/month |
| **Used For** | Specialized models (Qwen 3.5, Cosmos video, Llama variants) |
| **PM Key Name** | `NVIDIA_API_KEY` |
| **Signup** | NVIDIA Developer account (email + profile) |

**Why NVIDIA NIM?** Access to bleeding-edge models (Qwen 3.5 397B, Cosmos video generation) that aren't available elsewhere for free.

### Hugging Face

| Field | Value |
|-------|-------|
| **URL** | [huggingface.co](https://huggingface.co) |
| **Free Tier** | Unlimited CPU-basic Spaces ($0/month) |
| **Used For** | A2A agent hosting, model inference, dataset storage |
| **PM Key Name** | `HUGGINGFACE_TOKEN` |
| **Signup** | Email + username |

**Why Hugging Face?** Unlimited free CPU Spaces means we can deploy unlimited A2A agents at zero cost. Each agent gets its own Space with Docker support.

### GitHub

| Field | Value |
|-------|-------|
| **URL** | [github.com](https://github.com) |
| **Free Tier** | Unlimited public repos, 2,000 Actions minutes/month |
| **Used For** | Code hosting, Issues (bug library), A2A coordination, PR workflows |
| **PM Key Name** | `GITHUB_TOKEN` |
| **Auto-Detection** | If `gh auth status` succeeds, the token is extracted automatically |

## Manual Key Storage

If autonomous registration isn't possible (e.g., platform requires CAPTCHA), store keys manually:

```bash
spm run-action '{
  "action": "sin.passwordmanager.secret.put",
  "name": "GROQ_API_KEY",
  "value": "gsk_your_key_here",
  "description": "Groq API key for vision models",
  "tags": ["auth", "groq", "vision", "free-tier"]
}'
```

## Future Platforms

| Platform | Status | Use Case |
|----------|--------|----------|
| **Cloudflare** | Planned | Workers for edge compute, Pages for hosting |
| **Vercel** | Planned | Dashboard and web app hosting |
| **Google AI Studio** | Planned | Gemini API keys |
| **Anthropic** | Planned | Claude API (when free tier available) |
| **OpenAI** | Planned | GPT API access |
