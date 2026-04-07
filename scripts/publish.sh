#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/publish.sh <markdown-file> [tags]
# Example: ./scripts/publish.sh ~/notes/my-post.md "前端,React"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <markdown-file> [tags]"
  echo "Example: $0 ./my-post.md \"前端,React\""
  exit 1
fi

SOURCE_FILE="$1"
TAGS="${2:-}"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: File '$SOURCE_FILE' not found."
  exit 1
fi

# Get the blog root directory (script is in blog/scripts/)
BLOG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
POSTS_DIR="$BLOG_DIR/content/posts"

# Extract filename without extension for slug
FILENAME=$(basename "$SOURCE_FILE")
SLUG="${FILENAME%.*}"
# Sanitize slug: lowercase, replace spaces/underscores with hyphens
SLUG=$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed 's/[_ ]/-/g')

DEST_FILE="$POSTS_DIR/$SLUG.md"

# Check if file already has front matter (starts with ---)
HAS_FRONTMATTER=false
FIRST_LINE=$(head -n 1 "$SOURCE_FILE")
if [ "$FIRST_LINE" = "---" ]; then
  HAS_FRONTMATTER=true
fi

if [ "$HAS_FRONTMATTER" = true ]; then
  # Copy as-is
  cp "$SOURCE_FILE" "$DEST_FILE"
  echo "Copied with existing front matter."
else
  # Try to extract title from first H1
  TITLE=$(grep -m 1 '^# ' "$SOURCE_FILE" | sed 's/^# //' || echo "$SLUG")
  if [ -z "$TITLE" ]; then
    TITLE="$SLUG"
  fi
  DATE=$(date +"%Y-%m-%dT%H:%M:%S%z")

  # Build tags array
  TAGS_YAML=""
  if [ -n "$TAGS" ]; then
    TAGS_YAML="tags: ["
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
    for i in "${!TAG_ARRAY[@]}"; do
      TAG=$(echo "${TAG_ARRAY[$i]}" | xargs)  # trim whitespace
      if [ $i -gt 0 ]; then
        TAGS_YAML+=", "
      fi
      TAGS_YAML+="\"$TAG\""
    done
    TAGS_YAML+="]"
  fi

  # Write front matter + content
  {
    echo "---"
    echo "title: \"$TITLE\""
    echo "date: $DATE"
    echo "draft: false"
    if [ -n "$TAGS_YAML" ]; then
      echo "$TAGS_YAML"
    fi
    echo "---"
    echo ""
    # Skip the first H1 line if we used it as title
    if grep -q '^# ' "$SOURCE_FILE"; then
      sed '0,/^# /{/^# /d;}' "$SOURCE_FILE"
    else
      cat "$SOURCE_FILE"
    fi
  } > "$DEST_FILE"
  echo "Generated front matter for: $TITLE"
fi

echo "Published to: $DEST_FILE"

# Git operations
cd "$BLOG_DIR"
git add "$DEST_FILE"
git commit -m "publish: $SLUG"
git push

echo ""
echo "✓ Published and pushed! GitHub Actions will deploy shortly."
echo "  URL: https://weivwang.github.io/posts/$SLUG/"
