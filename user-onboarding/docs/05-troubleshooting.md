# Troubleshooting

## Common Issues

### Phase 2: GCP Setup

**Error: `Invalid JWT Signature`**

The service account key was rotated or revoked on Google's side (often because it was exposed in a git commit).

Fix:
1. Login as user: `gcloud auth login --no-launch-browser`
2. Create new key: `gcloud iam service-accounts keys create /tmp/new-key.json --iam-account=SA_EMAIL`
3. Replace: `cp /tmp/new-key.json ~/.config/opencode/auth/google/service-account.json`
4. Activate: `gcloud auth activate-service-account --key-file=~/.config/opencode/auth/google/service-account.json`

**Error: `Project creation failed`**

Google Cloud requires billing to create new projects. Either:
- Enable billing at [console.cloud.google.com/billing](https://console.cloud.google.com/billing)
- Or use an existing project: `gcloud config set project YOUR_PROJECT`

### Phase 3: Passwordmanager

**Output: `undefined` from run-action**

Wrong action name format. The correct patterns are:
- `sin.passwordmanager.secret.put` (not `set`)
- `sin.passwordmanager.secret.get` (not `get`)
- Parameters go at the top level, not nested under `input`

**Error: `Cannot find module`**

The TypeScript hasn't been built. Run:
```bash
cd ~/.config/sin/sin-passwordmanager/build
npm install && npx tsc
```

### Phase 4: Chrome Extension

**Extension not loading**

1. Verify files exist: `ls ~/.config/sin/opensin-bridge/manifest.json`
2. Check Chrome version: must be 120+
3. Ensure Developer Mode is ON in `chrome://extensions`
4. Check for errors in `chrome://extensions` (red error badge)

**Vision not working**

1. Check API keys are set in extension storage
2. Open service worker DevTools from `chrome://extensions`
3. Check console for rate limit or auth errors

### Phase 5: Platform Registration

**Can't auto-register (CAPTCHA)**

Some platforms use CAPTCHAs that block automated signup. In this case:
1. Register manually at the platform URL
2. Copy your API key
3. Store via: `spm run-action '{"action":"sin.passwordmanager.secret.put","name":"KEY_NAME","value":"your_key"}'`

## Reset & Re-Run

To reset onboarding state and re-run from scratch:

```bash
rm ~/.config/sin/onboarding-state.json
./scripts/onboard.sh
```

To re-run a specific phase:

```bash
bash scripts/phase3_passwordmanager.sh
```
