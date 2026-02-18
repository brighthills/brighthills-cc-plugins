#!/bin/bash
# publish.sh — Sync public GitHub repo from internal main branch
# Usage: ./publish.sh [commit message]
#
# Switches to public-main branch, pulls latest from main,
# removes private components, and pushes to GitHub.

set -e

MSG="${1:-Sync public release $(date +%Y-%m-%d)}"

# Files/dirs to EXCLUDE from public repo
EXCLUDE_PATHS=(
  plugins/bh-a11y
  CLAUDE.md
  .claude
)

# Plugin names to remove from marketplace.json
EXCLUDE_PLUGINS=(
  bh-a11y
)

echo "Switching to public-main..."
git checkout public-main

echo "Pulling latest from main..."
git checkout main -- .

# Remove excluded paths
for item in "${EXCLUDE_PATHS[@]}"; do
  if [ -e "$item" ]; then
    rm -rf "$item"
    echo "  Removed: $item"
  fi
done

# Filter marketplace.json — remove excluded plugins
FILTER=$(printf ' and .name != "%s"' "${EXCLUDE_PLUGINS[@]}")
FILTER="del(.plugins[] | select(false${FILTER} | not))"
jq "$FILTER" .claude-plugin/marketplace.json > tmp_marketplace.json \
  && mv tmp_marketplace.json .claude-plugin/marketplace.json
echo "  Filtered marketplace.json"

# Stage and check for changes
git add -A
if git diff --cached --quiet; then
  echo "No changes to publish."
  git checkout main
  exit 0
fi

git commit -m "$MSG"
git push public public-main:main
git checkout main

echo "Done. Public repo updated."
