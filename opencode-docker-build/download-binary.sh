#!/bin/bash
set -e

echo "=== OpenCode Binary Downloader ==="

BUILD_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST_DIR="${BUILD_DIR}/dist"
VERSION="${1:-1.3.17}"
ARCH=$(uname -m)

mkdir -p "${DIST_DIR}"

if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    echo "→ ARM64 (Mac M1/M2/M3)..."
    FOLDER="opencode-linux-arm64-musl"
    FILE="opencode-linux-arm64-musl.tar.gz"
else
    echo "→ x64 (Intel Mac, OCI VM, Cloud)..."
    FOLDER="opencode-linux-x64-baseline-musl"
    FILE="opencode-linux-x64-baseline-musl.tar.gz"
fi

mkdir -p "${DIST_DIR}/${FOLDER}/bin"

curl -sL "https://github.com/anomalyco/opencode/releases/download/v${VERSION}/${FILE}" \
  -o "/tmp/${FILE}"
tar -xzf "/tmp/${FILE}" -C /tmp/
mv "/tmp/opencode" "${DIST_DIR}/${FOLDER}/bin/"
chmod +x "${DIST_DIR}/${FOLDER}/bin/opencode"
rm -f "/tmp/${FILE}"

echo "  ✓ Binary: $(file "${DIST_DIR}/${FOLDER}/bin/opencode" | cut -d: -f2)"
echo ""
echo "Build image:"
echo "  docker build -t oc ."
