#!/usr/bin/env bash
set -euo pipefail

# Publishes the public Website workspace from Obsidian into the existing Quartz site.
# This script intentionally operates only on SOURCE and DESTINATION.

SOURCE="/Users/josuetrujo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Josue's Journal/Website/"
DESTINATION="/Users/josuetrujo/Documents/Websites/josuetrujo-site/content/"
SITE_DIR="/Users/josuetrujo/Documents/Websites/josuetrujo-site"
LIVE_URL="https://josuetrujo.github.io"

echo "Starting Obsidian to Quartz publish..."
echo "Source:      ${SOURCE}"
echo "Destination: ${DESTINATION}"

if [[ ! -d "${SOURCE}" ]]; then
  echo "ERROR: Source folder does not exist: ${SOURCE}" >&2
  exit 1
fi

if [[ ! -d "${DESTINATION}" ]]; then
  echo "ERROR: Destination folder does not exist: ${DESTINATION}" >&2
  exit 1
fi

if [[ ! -d "${SITE_DIR}" ]]; then
  echo "ERROR: Quartz site folder does not exist: ${SITE_DIR}" >&2
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "ERROR: rsync is not available on this Mac." >&2
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "ERROR: npx is not available. Install or repair Node.js/npm before publishing." >&2
  exit 1
fi

case "${SOURCE}" in
  "/Users/josuetrujo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Josue's Journal/Website/") ;;
  *)
    echo "ERROR: Refusing to publish from an unexpected source path: ${SOURCE}" >&2
    exit 1
    ;;
esac

case "${DESTINATION}" in
  "/Users/josuetrujo/Documents/Websites/josuetrujo-site/content/") ;;
  *)
    echo "ERROR: Refusing to publish to an unexpected destination path: ${DESTINATION}" >&2
    exit 1
    ;;
esac

echo "Syncing Website/ into Quartz content/..."
rsync -av --delete "${SOURCE}" "${DESTINATION}"

echo "Running Quartz sync..."
cd "${SITE_DIR}"
npx quartz sync --no-pull

echo "Publish complete. GitHub Pages deployment has been triggered."
echo "Live website: ${LIVE_URL}"
