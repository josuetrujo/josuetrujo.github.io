#!/usr/bin/env bash
set -euo pipefail

# Publishes the public Website workspace from Obsidian into the existing Quartz site.
# Markdown-oriented content goes through Quartz; standalone HTML sites are copied
# into the final GitHub Pages artifact by the deploy workflow.

SOURCE="/Users/josuetrujo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Josue's Journal/Website"
QUARTZ_ROOT="/Users/josuetrujo/Documents/Websites/josuetrujo-site"
QUARTZ_CONTENT="/Users/josuetrujo/Documents/Websites/josuetrujo-site/content"
STANDALONE_DEST="/Users/josuetrujo/Documents/Websites/josuetrujo-site/standalone-sites"
LIVE_URL="https://josuetrujo.github.io"
EXCLUDE_ARGS=(
  --exclude=".DS_Store"
  --exclude=".obsidian/"
  --exclude=".trash/"
  --exclude=".git/"
)

require_dir() {
  local path="$1"
  local label="$2"

  if [[ ! -d "${path}" ]]; then
    echo "ERROR: ${label} folder does not exist: ${path}" >&2
    exit 1
  fi
}

safe_remove_path() {
  local target="$1"
  local allowed_root="$2"

  case "${target}" in
    "${allowed_root}/"*) ;;
    *)
      echo "ERROR: Refusing to remove path outside ${allowed_root}: ${target}" >&2
      exit 1
      ;;
  esac

  rm -rf "${target}"
}

is_standalone_site() {
  local candidate="$1"
  local site

  for site in "${STANDALONE_SITES[@]}"; do
    if [[ "${site}" == "${candidate}" ]]; then
      return 0
    fi
  done

  return 1
}

echo "Starting Obsidian to Quartz publish..."
echo "Source:            ${SOURCE}"
echo "Quartz root:       ${QUARTZ_ROOT}"
echo "Quartz content:    ${QUARTZ_CONTENT}"
echo "Standalone sites:  ${STANDALONE_DEST}"

require_dir "${SOURCE}" "Source"
require_dir "${QUARTZ_ROOT}" "Quartz root"
require_dir "${QUARTZ_CONTENT}" "Quartz content"
mkdir -p "${STANDALONE_DEST}"

if ! command -v rsync >/dev/null 2>&1; then
  echo "ERROR: rsync is not available on this Mac." >&2
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "ERROR: npx is not available. Install or repair Node.js/npm before publishing." >&2
  exit 1
fi

case "${SOURCE}" in
  "/Users/josuetrujo/Library/Mobile Documents/iCloud~md~obsidian/Documents/Josue's Journal/Website") ;;
  *)
    echo "ERROR: Refusing to publish from an unexpected source path: ${SOURCE}" >&2
    exit 1
    ;;
esac

case "${QUARTZ_ROOT}" in
  "/Users/josuetrujo/Documents/Websites/josuetrujo-site") ;;
  *)
    echo "ERROR: Refusing to publish from an unexpected Quartz root: ${QUARTZ_ROOT}" >&2
    exit 1
    ;;
esac

case "${QUARTZ_CONTENT}" in
  "${QUARTZ_ROOT}/content") ;;
  *)
    echo "ERROR: Refusing to publish to an unexpected Quartz content path: ${QUARTZ_CONTENT}" >&2
    exit 1
    ;;
esac

case "${STANDALONE_DEST}" in
  "${QUARTZ_ROOT}/standalone-sites") ;;
  *)
    echo "ERROR: Refusing to publish to an unexpected standalone-sites path: ${STANDALONE_DEST}" >&2
    exit 1
    ;;
esac

STANDALONE_SITES=()
while IFS= read -r site_dir; do
  [[ -z "${site_dir}" ]] && continue
  STANDALONE_SITES+=("$(basename "${site_dir}")")
done < <(find "${SOURCE}" -mindepth 1 -maxdepth 1 -type d -exec test -f "{}/index.html" \; -print | sort)

CONTENT_ITEMS=()
while IFS= read -r item_path; do
  [[ -z "${item_path}" ]] && continue
  item_name="$(basename "${item_path}")"

  case "${item_name}" in
    ".DS_Store"|".obsidian"|".trash"|".git")
      continue
      ;;
  esac

  if [[ -d "${item_path}" ]] && is_standalone_site "${item_name}"; then
    continue
  fi

  CONTENT_ITEMS+=("${item_name}")
done < <(find "${SOURCE}" -mindepth 1 -maxdepth 1 -print | sort)

echo
echo "Detected standalone HTML site folders:"
if [[ "${#STANDALONE_SITES[@]}" -eq 0 ]]; then
  echo "  (none)"
else
  for site in "${STANDALONE_SITES[@]}"; do
    echo "  - ${site}"
  done
fi

echo
echo "Syncing to Quartz content:"
if [[ "${#CONTENT_ITEMS[@]}" -eq 0 ]]; then
  echo "  (none)"
else
  for item in "${CONTENT_ITEMS[@]}"; do
    echo "  - ${item}"
  done
fi

echo
echo "Syncing to standalone-sites:"
if [[ "${#STANDALONE_SITES[@]}" -eq 0 ]]; then
  echo "  (none)"
else
  for site in "${STANDALONE_SITES[@]}"; do
    echo "  - ${site}"
  done
fi

exclude_file="$(mktemp)"
standalone_stage="$(mktemp -d)"
trap 'rm -f "${exclude_file}"; rm -rf "${standalone_stage}"' EXIT

{
  echo ".DS_Store"
  echo ".obsidian/"
  echo ".trash/"
  echo ".git/"
  for site in "${STANDALONE_SITES[@]}"; do
    echo "/${site}/"
  done
} > "${exclude_file}"

echo
echo "Cleaning old standalone copies from Quartz content..."
for site in "${STANDALONE_SITES[@]}"; do
  content_site="${QUARTZ_CONTENT}/${site}"
  if [[ -e "${content_site}" ]]; then
    echo "  Removing ${content_site}"
    safe_remove_path "${content_site}" "${QUARTZ_CONTENT}"
  fi
done

echo
echo "Syncing standalone HTML sites into standalone-sites/..."
for site in "${STANDALONE_SITES[@]}"; do
  mkdir -p "${standalone_stage}/${site}"
  rsync -av --delete "${EXCLUDE_ARGS[@]}" "${SOURCE}/${site}/" "${standalone_stage}/${site}/"
done
rsync -av --delete "${EXCLUDE_ARGS[@]}" "${standalone_stage}/" "${STANDALONE_DEST}/"

echo
echo "Syncing Markdown-oriented Website content into Quartz content/..."
rsync -av --delete --exclude-from="${exclude_file}" "${SOURCE}/" "${QUARTZ_CONTENT}/"

echo
echo "Triggering GitHub Pages deployment with Quartz sync..."
cd "${QUARTZ_ROOT}"
npx quartz sync --no-pull

echo "Publish complete. GitHub Pages deployment has been triggered."
echo "Live website: ${LIVE_URL}"
if [[ "${#STANDALONE_SITES[@]}" -gt 0 ]]; then
  echo "Standalone site URLs:"
  for site in "${STANDALONE_SITES[@]}"; do
    echo "  ${LIVE_URL}/${site}/"
  done
fi
