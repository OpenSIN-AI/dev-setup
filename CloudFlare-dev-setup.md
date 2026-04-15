# Cloudflare Pages Setup Guide

> **Critical SPA Mode Rule (CRITICAL - NEVER FORGET)**
> Cloudflare Pages activates SPA mode automatically when NO 404.html exists in build output.
> - SPA active (NO 404.html): All routes handled by SPA -> HTTP 200
> - SPA inactive (404.html exists): Normal 404 behavior -> HTTP 404

## Problem: Authority Pages Return HTTP 404

All 6 authority pages on opensin.ai return HTTP 404 because public/404.html DISABLES Cloudflare Pages SPA mode.

## Root Cause
Creating public/404.html causes Cloudflare Pages to use normal 404 behavior instead of SPA routing.

## The Fix
REMOVE public/404.html from the build output. Cloudflare Pages will automatically activate SPA mode when no 404.html exists.

## How to Deploy

The opensin-website project is NOT connected to Git. Use wrangler CLI:

```bash
cd ~/dev/website-opensin.ai
bun run build
CLOUDFLARE_API_TOKEN=TOKEN wrangler pages deploy . --project-name=opensin-website
```

## Common Mistakes (NEVER DO THESE)

1. Creating public/404.html -> DISABLES SPA mode, ALL routes return 404
2. Adding _routes or _redirects files -> Not needed when SPA mode is active
3. Using npm instead of bun -> Builds get OOM killed on Mac
4. Git push expecting deployment -> Project is not Git-connected, use wrangler

## Build Commands (bun ONLY)

```bash
bun install
bun run build
bun run preview
```

## Verification

```bash
for page in ai-agents a2a-protocol multi-agent-orchestration autonomous-ai-agents openclaw-alternative claude-code-alternative; do
  code=\$(curl -s -o /dev/null -w "%{http_code}" "https://opensin.ai/\$page")
  echo "\$page: \$code"
done
```

Expected: all return 200.
