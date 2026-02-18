#!/usr/bin/env bash
set -euo pipefail

SOURCE_PLUGIN="../claude-marketplace/dd"
DEST_PLUGIN="plugins/tal"

usage() {
  echo "Usage: $0 <type> <path>"
  echo ""
  echo "Sync a skill or command from the dd plugin to the local tal plugin."
  echo ""
  echo "  type   'skill' or 'command'"
  echo "  path   path relative to the type directory (e.g. git/commit/quick)"
  echo ""
  echo "Examples:"
  echo "  $0 command git/commit/quick"
  echo "  $0 skill git/partial-commit"
  echo ""
  echo "Available:"
  echo "  Commands:"
  find "$SOURCE_PLUGIN/commands" -name '*.md' | sed "s|$SOURCE_PLUGIN/commands/||; s|\.md$||" | sort | sed 's/^/    /'
  echo "  Skills:"
  find "$SOURCE_PLUGIN/skills" -mindepth 1 -maxdepth 1 -type d | sed "s|$SOURCE_PLUGIN/skills/||" | sort | sed 's/^/    /'
  exit 1
}

[[ $# -lt 2 ]] && usage

TYPE="$1"
ITEM_PATH="$2"

# Rewrite dd -> tal references in synced .md files
rewrite_refs() {
  local target="$1"
  local files=()

  if [[ -d "$target" ]]; then
    while IFS= read -r -d '' f; do files+=("$f"); done < <(find "$target" -name '*.md' -print0)
  elif [[ -f "$target" ]]; then
    files=("$target")
  fi

  local count=0
  for f in "${files[@]}"; do
    if grep -qE '/dd:|claude-marketplace/tree/main/dd/' "$f" 2>/dev/null; then
      sed -i '' \
        -e 's|/dd:|/tal:|g' \
        -e 's|github\.com/DataDog/claude-marketplace/tree/main/dd/|github.com/tal/claude-marketplace/tree/main/plugins/tal/|g' \
        "$f"
      count=$((count + 1))
    fi
  done
  [[ $count -gt 0 ]] && echo "Rewrote dd -> tal references in $count file(s)"
}

case "$TYPE" in
  command|commands)
    TYPE_DIR="commands"
    # Commands are single .md files; path may or may not include .md
    SRC_FILE="$SOURCE_PLUGIN/$TYPE_DIR/${ITEM_PATH%.md}.md"
    if [[ ! -f "$SRC_FILE" ]]; then
      echo "Error: source not found: $SRC_FILE" >&2
      exit 1
    fi
    DEST_FILE="$DEST_PLUGIN/$TYPE_DIR/${ITEM_PATH%.md}.md"
    mkdir -p "$(dirname "$DEST_FILE")"
    cp "$SRC_FILE" "$DEST_FILE"
    rewrite_refs "$DEST_FILE"
    echo "Synced command: $DEST_FILE"
    ;;
  skill|skills)
    TYPE_DIR="skills"
    SRC_DIR="$SOURCE_PLUGIN/$TYPE_DIR/$ITEM_PATH"
    if [[ ! -d "$SRC_DIR" ]]; then
      # Maybe it's a single file skill
      SRC_FILE="$SOURCE_PLUGIN/$TYPE_DIR/${ITEM_PATH%.md}.md"
      if [[ -f "$SRC_FILE" ]]; then
        DEST_FILE="$DEST_PLUGIN/$TYPE_DIR/${ITEM_PATH%.md}.md"
        mkdir -p "$(dirname "$DEST_FILE")"
        cp "$SRC_FILE" "$DEST_FILE"
        rewrite_refs "$DEST_FILE"
        echo "Synced skill file: $DEST_FILE"
        exit 0
      fi
      echo "Error: source not found: $SRC_DIR" >&2
      exit 1
    fi
    DEST_DIR="$DEST_PLUGIN/$TYPE_DIR/$ITEM_PATH"
    mkdir -p "$DEST_DIR"
    rsync -av --delete "$SRC_DIR/" "$DEST_DIR/"
    rewrite_refs "$DEST_DIR"
    echo "Synced skill directory: $DEST_DIR"
    ;;
  *)
    echo "Error: type must be 'skill' or 'command', got '$TYPE'" >&2
    exit 1
    ;;
esac
