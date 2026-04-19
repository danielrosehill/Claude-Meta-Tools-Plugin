#!/usr/bin/env bash
# Refresh cached issue-form templates from anthropics/claude-code.
# Diffs against the local cache and reports changes.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_URL="https://raw.githubusercontent.com/anthropics/claude-code/main/.github/ISSUE_TEMPLATE"

declare -A TEMPLATES=(
  [bug]="bug_report.yml"
  [feature-request]="feature_request.yml"
  [model-behavior]="model_behavior.yml"
  [docs]="documentation.yml"
)

CHANGED=0
MISSING=()

for skill in "${!TEMPLATES[@]}"; do
  file="${TEMPLATES[$skill]}"
  dest="$PLUGIN_ROOT/skills/$skill/templates/$file"
  tmp="$(mktemp)"

  if ! curl -fsSL "$BASE_URL/$file" -o "$tmp"; then
    echo "ERROR: could not fetch $file" >&2
    MISSING+=("$file")
    rm -f "$tmp"
    continue
  fi

  if [[ ! -f "$dest" ]]; then
    mv "$tmp" "$dest"
    echo "NEW    $file"
    CHANGED=$((CHANGED+1))
  elif ! diff -q "$dest" "$tmp" >/dev/null; then
    mv "$tmp" "$dest"
    echo "UPDATE $file"
    CHANGED=$((CHANGED+1))
  else
    rm -f "$tmp"
    echo "OK     $file"
  fi
done

# Discover templates we don't know about yet (Anthropic adding new issue types).
REMOTE_LIST="$(gh api repos/anthropics/claude-code/contents/.github/ISSUE_TEMPLATE --jq '.[].name' 2>/dev/null || true)"
if [[ -n "$REMOTE_LIST" ]]; then
  KNOWN="bug_report.yml feature_request.yml model_behavior.yml documentation.yml config.yml"
  while IFS= read -r remote; do
    if ! grep -qw "$remote" <<<"$KNOWN"; then
      echo "NEW TEMPLATE TYPE DETECTED: $remote — plugin needs a new skill for this"
    fi
  done <<<"$REMOTE_LIST"
fi

if (( ${#MISSING[@]} > 0 )); then
  echo
  echo "WARN: ${#MISSING[@]} template(s) could not be fetched; cached versions retained."
  exit 2
fi

echo
echo "Done. $CHANGED template(s) updated."
