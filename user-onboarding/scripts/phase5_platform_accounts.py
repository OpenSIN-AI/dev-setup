#!/usr/bin/env python3
"""
Phase 5: Autonomous platform account registration and API key provisioning.

Registers accounts on free-tier AI platforms and stores API keys
in the SIN-Passwordmanager (Google Cloud Secrets backend).

Supported platforms:
  - Groq (14,400 free vision requests/day)
  - NVIDIA NIM (1,000 free API calls/month)
  - Hugging Face (unlimited free CPU Spaces)
"""

import json
import os
import subprocess
import sys
import time

PM_CLI = os.path.expanduser("~/.config/sin/sin-passwordmanager/build/dist/src/cli.js")
SPM_BACKEND = os.environ.get("SPM_SECRET_BACKEND", "gcloud")

GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
BLUE = "\033[0;34m"
NC = "\033[0m"


def log(msg):
    print(f"{GREEN}[✓]{NC} {msg}")


def warn(msg):
    print(f"{YELLOW}[!]{NC} {msg}")


def info(msg):
    print(f"{BLUE}[→]{NC} {msg}")


PLATFORMS = [
    {
        "name": "Groq",
        "key_name": "GROQ_API_KEY",
        "signup_url": "https://console.groq.com/keys",
        "description": "Free vision models (llama-3.2-11b-vision, llama-4-scout)",
        "free_tier": "14,400 requests/day",
        "tags": ["auth", "groq", "vision", "free-tier"],
    },
    {
        "name": "NVIDIA NIM",
        "key_name": "NVIDIA_API_KEY",
        "signup_url": "https://build.nvidia.com/",
        "description": "Free NIM API (Qwen, Cosmos, Llama models)",
        "free_tier": "1,000 API calls/month",
        "tags": ["auth", "nvidia", "nim", "free-tier"],
    },
    {
        "name": "Hugging Face",
        "key_name": "HUGGINGFACE_TOKEN",
        "signup_url": "https://huggingface.co/settings/tokens",
        "description": "Unlimited free CPU Spaces for A2A agent hosting",
        "free_tier": "Unlimited CPU-basic Spaces",
        "tags": ["auth", "huggingface", "spaces"],
    },
    {
        "name": "GitHub",
        "key_name": "GITHUB_TOKEN",
        "signup_url": "https://github.com/settings/tokens",
        "description": "GitHub API access for repo management and A2A coordination",
        "free_tier": "Unlimited public repos",
        "tags": ["auth", "github"],
    },
]


def pm_action(action_payload: dict) -> dict | None:
    try:
        result = subprocess.run(
            ["node", PM_CLI, "run-action", json.dumps(action_payload)],
            capture_output=True,
            text=True,
            timeout=30,
            env={**os.environ, "SPM_SECRET_BACKEND": SPM_BACKEND},
        )
        if result.stdout.strip() and result.stdout.strip() != "undefined":
            return json.loads(result.stdout.strip())
    except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError):
        pass
    return None


def check_key_exists(key_name: str) -> bool:
    result = pm_action({
        "action": "sin.passwordmanager.secret.get",
        "name": key_name,
        "reveal": False,
    })
    return result is not None and "name" in result


def store_key(key_name: str, value: str, description: str, tags: list[str]) -> bool:
    result = pm_action({
        "action": "sin.passwordmanager.secret.put",
        "name": key_name,
        "value": value,
        "description": description,
        "tags": tags,
    })
    return result is not None and "name" in result


def try_autonomous_registration(platform: dict) -> str | None:
    """
    Attempt to register on a platform autonomously using browser automation.
    Returns the API key if successful, None if manual input is needed.
    
    This uses the Two-Layer Browser Stack (nodriver + CDP) when available.
    Falls back to prompting the user for the key.
    """
    try:
        cdp_check = subprocess.run(
            ["curl", "-s", "http://localhost:9335/json/version"],
            capture_output=True, text=True, timeout=3
        )
        if cdp_check.returncode == 0 and "Chrome" in cdp_check.stdout:
            info(f"  Chrome CDP available — attempting autonomous {platform['name']} registration...")
            info(f"  Opening: {platform['signup_url']}")
            # TODO: Full browser automation for each platform
            # For now, open the URL and let user complete registration
            subprocess.run(
                ["open", platform["signup_url"]],
                timeout=5
            )
            time.sleep(2)
            return None
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return None


def main():
    info("Phase 5: Platform Account Registration")
    print()

    if not os.path.exists(PM_CLI):
        warn(f"Passwordmanager CLI not found at {PM_CLI}")
        warn("Skipping platform registration — run Phase 3 first")
        return

    stored_count = 0
    skipped_count = 0
    manual_needed = []

    for platform in PLATFORMS:
        key_name = platform["key_name"]
        info(f"Checking {platform['name']}...")

        if check_key_exists(key_name):
            log(f"  {key_name} already exists in Passwordmanager")
            skipped_count += 1
            continue

        auto_key = try_autonomous_registration(platform)

        if auto_key:
            if store_key(auto_key, auto_key, platform["description"], platform["tags"]):
                log(f"  {key_name} stored autonomously!")
                stored_count += 1
                continue

        gh_token = None
        if key_name == "GITHUB_TOKEN":
            try:
                result = subprocess.run(
                    ["gh", "auth", "token"],
                    capture_output=True, text=True, timeout=5
                )
                if result.returncode == 0 and result.stdout.strip():
                    gh_token = result.stdout.strip()
                    info(f"  Found GitHub token from gh CLI")
            except (subprocess.TimeoutExpired, FileNotFoundError):
                pass

        if gh_token:
            if store_key(key_name, gh_token, platform["description"], platform["tags"]):
                log(f"  {key_name} stored from gh CLI")
                stored_count += 1
                continue

        manual_needed.append(platform)

    if manual_needed:
        print()
        warn(f"{len(manual_needed)} platform(s) need API keys. Register at:")
        print()
        for p in manual_needed:
            print(f"  {p['name']:20s} → {p['signup_url']}")
            print(f"  {'':20s}   Free tier: {p['free_tier']}")
            print()

        print("After getting your keys, store them with:")
        print()
        for p in manual_needed:
            print(f"  spm run-action '{json.dumps({\"action\": \"sin.passwordmanager.secret.put\", \"name\": p[\"key_name\"], \"value\": \"YOUR_KEY_HERE\", \"description\": p[\"description\"], \"tags\": p[\"tags\"]})}'")
        print()

    log(f"Phase 5 complete — {stored_count} keys stored, {skipped_count} already existed, {len(manual_needed)} need manual input")


if __name__ == "__main__":
    main()
