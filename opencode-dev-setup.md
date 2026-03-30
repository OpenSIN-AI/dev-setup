# 🚀 OpenCode Developer Setup & SSOT Synchronization

Welcome to the OpenSIN-AI engineering team! 
To ensure that all developers, agents, and VMs operate with **100% identical configurations**, we use a strict Single Source of Truth (SSOT) architecture. 

This guide explains how to install our forked version of OpenCode and set up the background daemon that will automatically keep your local environment (plugins, skills, MCPs, and models) perfectly synced with the core team within 60 seconds of any update.

---

## 🛑 Golden Rule: Zero Local Drift
- **NEVER** edit your `~/.config/opencode/opencode.json` manually.
- **NEVER** modify `.opencode/` or `fleet-config/` folders inside your local project directories.
- Any local changes will be **forcefully overwritten** by the SSOT Daemon every 60 seconds. 
- If you need a new tool, skill, or plugin, submit a PR to the `global-opencode-config/` directory in our `Delqhi/sin-opencode` repository. Once merged, it will deploy to everyone globally.

---

## Step 1: Install the OpenSIN Forked OpenCode

Do not use the standard upstream `opencode` binary. We maintain our own fork optimized for the OpenSIN-AI ecosystem.

```bash
# Clone our fork
git clone git@github.com:Delqhi/sin-opencode.git ~/dev/sin-opencode
cd ~/dev/sin-opencode

# Install dependencies and build (using pnpm or your preferred package manager)
pnpm install
pnpm run build

# Link the binary globally so `opencode` is available everywhere
pnpm link --global
```
*(Verify installation by running `opencode --version`)*

---

## Step 2: Install the SSOT Daemon (Mac & Linux)

The SSOT (Single Source of Truth) Daemon is a tiny, bulletproof bash script that runs in the background. It fetches our configuration repository every 60 seconds and forcefully applies the exact global configuration to your machine and all your local projects.

### 🍎 For macOS Users (Native LaunchDaemon)

Run the following commands in your terminal to create and load the background daemon:

```bash
mkdir -p ~/.config/opencode/scripts

# 1. Download the SSOT Daemon script directly from our repo
curl -sL "https://raw.githubusercontent.com/Delqhi/sin-opencode/main/global-opencode-config/scripts/ssot-daemon.sh" -o ~/.config/opencode/scripts/ssot-daemon.sh
chmod +x ~/.config/opencode/scripts/ssot-daemon.sh

# 2. Create the macOS LaunchAgent
cat > ~/Library/LaunchAgents/com.opencode.ssot-daemon.plist << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.opencode.ssot-daemon</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>exec ~/.config/opencode/scripts/ssot-daemon.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/opencode-ssot-daemon.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/opencode-ssot-daemon.err</string>
</dict>
</plist>

# 3. Start the Daemon
launchctl load ~/Library/LaunchAgents/com.opencode.ssot-daemon.plist
```
*You can monitor the sync status anytime by viewing `/tmp/opencode-ssot-daemon.log`.*

### 🐧 For Linux / VM Users (HF Spaces, OCI VMs)

For environments without `launchd`, use `nohup` to run the daemon continuously:

```bash
mkdir -p ~/.config/opencode/scripts

# 1. Download the script
curl -sL "https://raw.githubusercontent.com/Delqhi/sin-opencode/main/global-opencode-config/scripts/ssot-daemon.sh" -o ~/.config/opencode/scripts/ssot-daemon.sh
chmod +x ~/.config/opencode/scripts/ssot-daemon.sh

# 2. Start it in the background
nohup ~/.config/opencode/scripts/ssot-daemon.sh > /tmp/opencode-ssot-daemon.log 2>&1 &
```
*Note: If you are building a new A2A Agent Docker image, ensure the `nohup` command is included in your `start.sh` or `CMD` directive.*

---

## Step 3: Verify the Synchronization

Wait about 60 seconds after starting the daemon. You should see the following happen automatically:

1. The directory `~/.config/opencode/` will be populated with our `opencode.json`, `mcp.json`, `skills/`, `plugins/`, and `tools/`.
2. Any project you have in `~/dev/` (e.g., `~/dev/OpenSIN-backend`) will suddenly have its local `.opencode/` folder perfectly mirrored to match the global configuration.
3. OpenCode will now have access to all our custom Antigravity models (`google/antigravity-gemini-3.1-pro`, `google/antigravity-claude-opus-4-6-thinking`, etc.) and all `/slash` skills via the `oh-my-opencode` plugin.

Welcome aboard. You are now 100% synchronized! 🚀
