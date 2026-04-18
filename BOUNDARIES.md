# dev-setup Boundaries

## Role
`dev-setup` documents and standardizes development environment setup for OpenSIN systems.

Short version:

- **This repo = setup and environment standards**
- **Not this repo = first-run product onboarding, product shell, or control-plane truth**

---

## Canonical Ownership

| Concern | Canonical Repo |
|---|---|
| Environment and setup standards | `dev-setup` |
| First-run onboarding automation | `OpenSIN-onboarding` |
| Product web app | `OpenSIN-WebApp` |
| Internal ops control plane | `ai-agent-system` |
| Official documentation | `OpenSIN-documentation` |
| OpenCode config canon | `upgraded-opencode-stack` |

---

## Hard rules

### 1. Setup standards, not onboarding monopoly
This repo may define stable environment setup guidance. It must not absorb all first-run automation flows that belong in onboarding.

### 2. Setup standards, not product or ops surface
This repo must not become the product app, account portal, or operator control plane.

### 3. Setup alignment, not config canon ownership
This repo should reference canonical config where needed rather than silently becoming the config source of truth.
