#!/usr/bin/env bash
set -euo pipefail

# Install Gradle locally in the project (no system package manager required).
# Usage:
#   ./scripts/install-gradle.sh [version]
# Example:
#   ./scripts/install-gradle.sh 8.14.3

GRADLE_VERSION="${1:-8.14.3}"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$PROJECT_ROOT/.tools"
INSTALL_DIR="$TOOLS_DIR/gradle-$GRADLE_VERSION"
DIST_DIR="$TOOLS_DIR/dist"
ZIP_FILE="$DIST_DIR/gradle-$GRADLE_VERSION-bin.zip"
DOWNLOAD_URL="https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"

mkdir -p "$TOOLS_DIR" "$DIST_DIR"

if [[ -x "$INSTALL_DIR/bin/gradle" ]]; then
  echo "Gradle $GRADLE_VERSION already installed at: $INSTALL_DIR"
else
  echo "Downloading Gradle $GRADLE_VERSION ..."
  curl -fL "$DOWNLOAD_URL" -o "$ZIP_FILE"

  echo "Extracting to $TOOLS_DIR ..."
  rm -rf "$INSTALL_DIR"
  unzip -q -o "$ZIP_FILE" -d "$TOOLS_DIR"
fi

LOCAL_GRADLE_BIN="$INSTALL_DIR/bin/gradle"
if [[ ! -x "$LOCAL_GRADLE_BIN" ]]; then
  echo "Error: expected Gradle binary not found at $LOCAL_GRADLE_BIN" >&2
  exit 1
fi

echo "Gradle installed successfully."
echo "Use it with:"
echo "  $LOCAL_GRADLE_BIN -v"
echo "  $LOCAL_GRADLE_BIN wrapper --no-validate-url"

echo "Tip: add to PATH for current shell:"
echo "  export PATH=\"$INSTALL_DIR/bin:\$PATH\""
