# Prerequisites

Before running the OpenSIN onboarding, ensure you have:

## Required

| Requirement | Minimum Version | Install |
|------------|----------------|---------|
| **macOS** | 12+ (Monterey) | — |
| **Bun** | 1.3+ (ERSTER Schritt!) | `brew install oven-sh/bun/bun` |
| **Node.js** | 18+ | `brew install node` |
| **Python** | 3.11+ | `brew install python3` |
| **Git** | 2.30+ | `brew install git` |
| **Google Chrome** | 120+ | [Download](https://www.google.com/chrome/) |
| **GitHub CLI** | 2.0+ | `brew install gh` |

> ⚠️ **ACHTUNG:** Bun MUSS vor allen anderen Schritten installiert werden. `npm` und `npx` sind im OpenSIN-Ökosystem PERMANENT VERBOTEN (OOM-Killer crasht den Mac). Verwende AUSSCHLIESSLICH `bun install`, `bun run`, `bunx`.

## Required Accounts

| Account | Purpose | Sign Up |
|---------|---------|---------|
| **Google Account** | GCP project for Secret Manager | [accounts.google.com](https://accounts.google.com) |
| **GitHub Account** | Code hosting, A2A coordination | [github.com/signup](https://github.com/signup) |

## Optional (Auto-Registered During Onboarding)

| Account | Purpose | Free Tier |
|---------|---------|-----------|
| **Groq** | Vision models for OpenSIN Bridge | 14,400 req/day |
| **NVIDIA NIM** | Specialized AI models | 1,000 calls/month |
| **Hugging Face** | A2A agent hosting | Unlimited CPU Spaces |

## Pre-Flight Check

```bash
node --version    # Must be 18+
python3 --version # Must be 3.11+
git --version     # Must be 2.30+
gh auth status    # Must be logged in
```
