#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$REPO_DIR/dist"
VERSION="${1:-$(date +%Y%m%d)}"
PACKAGE_SLUG="mjlab-skillkit"
PKG_NAME="${PACKAGE_SLUG}-${VERSION}"

mkdir -p "$DIST_DIR"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

rsync -a \
  --exclude '.git/' \
  --exclude 'dist/' \
  "$REPO_DIR/" "$TMP_DIR/$PKG_NAME/"

(
  cd "$TMP_DIR"
  tar -czf "$DIST_DIR/$PKG_NAME.tar.gz" "$PKG_NAME"
  zip -qr "$DIST_DIR/$PKG_NAME.zip" "$PKG_NAME"
)

echo "Created: $DIST_DIR/$PKG_NAME.tar.gz"
echo "Created: $DIST_DIR/$PKG_NAME.zip"
