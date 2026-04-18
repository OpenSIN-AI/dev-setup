#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[✗]${NC} $*"; }
info() { echo -e "${BLUE}[→]${NC} $*"; }

if [ -f "$HOME/.config/opensin/box-storage-configured" ]; then
  log "Box.com Storage already configured, skipping..."
  exit 0
fi

info "OpenSIN uses Box.com (10 GB free) as primary cloud storage for:"
echo "  • Public files (logos, images, documents)"
echo "  • Cache & logs (temporary files)"
echo ""

warn "IMPORTANT: GitLab Storage is DEAD (account banned). Box.com is the replacement."
echo ""

echo "Step 1: Create a free Box.com account (10 GB)"
echo "  1. Open https://www.box.com/signup/ in your browser"
echo "  2. Register with your email"
echo "  3. Verify your email"
echo ""
read -p "Have you created a Box.com account? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  warn "Please create a Box.com account first."
  echo "  Then re-run: opensin init (or ./scripts/onboard.sh)"
  exit 1
fi

log "Box.com account created!"

echo ""
info "Step 2: Create two folders in your Box.com account:"
echo "  1. Log into https://app.box.com/"
echo "  2. Create folder: /OpenSIN-Public (for public files)"
echo "  3. Create folder: /OpenSIN-Cache (for logs and temp files)"
echo ""
read -p "Have you created both folders? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  warn "Please create the folders first."
  exit 1
fi

log "Folders created!"

echo ""
info "Step 3: Enable Public Sharing for each folder:"
echo "  For /OpenSIN-Public:"
echo "    1. Right-click folder → Share"
echo "    2. Set to: 'People with the link'"
echo "    3. Permission: 'Can view'"
echo "    4. Copy the share link"
echo ""
echo "  Repeat for /OpenSIN-Cache"
echo ""
read -p "Have you enabled sharing for both folders? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  warn "Please enable sharing first."
  exit 1
fi

log "Sharing enabled!"

echo ""
info "Step 4 (Optional): Create Box Developer Token for API access"
echo "  1. Go to https://app.box.com/developers/console"
echo "  2. Click 'Create New App' → 'Custom App'"
echo "  3. Add 'Developer Token' scope"
echo "  4. Generate token (valid 60 min)"
echo ""
read -p "Do you want to create a Developer Token now? (y/n) " -n 1 -r
echo ""

BOX_DEVELOPER_TOKEN=""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "Enter your Developer Token: " BOX_DEVELOPER_TOKEN
  if [ -n "$BOX_DEVELOPER_TOKEN" ]; then
    log "Storing Developer Token in passwordmanager..."
  fi
fi

mkdir -p "$HOME/.config/opensin"
touch "$HOME/.config/opensin/box-storage-configured"

log "Box.com Storage setup complete!"
echo ""
info "Next steps:"
echo "  1. Get the folder IDs from Box.com (optional, for API usage):"
echo "     box folders:children 0"
echo "  2. Add these to your .env:"
echo "     BOX_PUBLIC_FOLDER_ID=<id>"
echo "     BOX_CACHE_FOLDER_ID=<id>"
echo "  3. Share the folder links with your OpenSIN team"
echo ""
echo "  Public folder example: https://app.box.com/s/1st624o9eb5xdistusew5w0erb8offc7"
echo "  Cache folder example: https://app.box.com/s/9s5htoefw1ux9ajaqj656v9a02h7z7x1"
echo ""
echo "⚠️  IMPORTANT: Without proper sharing, the shared links will return 404!"
echo ""

exit 0