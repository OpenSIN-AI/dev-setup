# OpenSIN Bridge Chrome Extension

OpenSIN Bridge is the Chrome extension that gives AI agents eyes and hands in the browser — CDP-based vision analysis, page inspection, and action execution.

## What It Does

| Capability | Tools | Description |
|-----------|-------|-------------|
| **CDP Agent Vision** | 9 tools | Screenshot, DOM inspection, JS execution, network monitoring |
| **Multi-Provider Vision** | 4 tools | AI-powered image analysis via Gemini + Groq fallback chain |
| **Security** | 36 hardening fixes | CSP headers, input sanitization, origin verification |
| **Tab Management** | Tab CRUD | Create, navigate, close, list tabs |

## Vision Provider Chain

The extension tries providers in order until one succeeds:

| Priority | Provider | Model | Free Tier |
|----------|----------|-------|-----------|
| 1 | Gemini | gemini-2.5-flash | 500 req/day |
| 2 | Gemini | gemini-1.5-flash | 1,500 req/day |
| 3 | Gemini | gemini-3-flash-preview | 500 req/day |
| 4 | Groq | llama-3.2-11b-vision | 14,400 req/day |
| 5 | Groq | llama-4-scout-17b | 1,000 req/day |
| 6 | Groq | llama-3.2-90b-vision | 1,000 req/day |
| 7 | Gemini | gemini-2.5-pro | 25 req/day |

**Total free capacity: ~18,000+ vision requests/day**

## Installation

### During Onboarding (Automatic)

The onboarding script (`phase4_chrome_extension.sh`) copies the extension files to `~/.config/sin/opensin-bridge/` and provides instructions for loading.

### Manual Installation

1. Open Chrome → `chrome://extensions`
2. Enable **Developer mode** (top-right toggle)
3. Click **Load unpacked**
4. Select folder: `~/.config/sin/opensin-bridge/`
5. Pin the extension icon in the toolbar

### CLI-Based Loading

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --load-extension="$HOME/.config/sin/opensin-bridge" \
  --remote-debugging-port=9335
```

## API Key Configuration

The extension needs at least one vision API key. During onboarding, keys are stored in the Passwordmanager. The extension reads them from:

1. **Extension storage** (set via popup or `chrome.storage.sync`)
2. **Hardcoded fallback** in `service_worker.js` (populated during onboarding)

To set keys manually:

```javascript
chrome.storage.sync.set({
  groqApiKey: "gsk_...",
  geminiApiKey: "AIzaSy..."
});
```

## Extension ID

After loading, the extension gets a unique ID. You can find it at `chrome://extensions`. Use this ID in your `opencode.json` MCP configuration to connect the extension to OpenSIN agents.

## Updating

```bash
cd ~/.config/sin/opensin-bridge
git pull origin main
```

Then reload the extension in `chrome://extensions` (click the refresh icon).
