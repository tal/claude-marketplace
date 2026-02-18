#!/usr/bin/env bash

# stage-lines.sh - Stage specific lines from a file using git apply --cached
#
# Usage: stage-lines.sh <file> <patch>
#   file: Path to the file to stage changes from
#   patch: Unified diff patch string to apply to staging area
#
# Example:
#   stage-lines.sh foo.txt "$(cat <<'EOF'
#   diff --git a/foo.txt b/foo.txt
#   index abcdef..123456 100644
#   --- a/foo.txt
#   +++ b/foo.txt
#   @@ -10,0 +11,1 @@
#   +this is the line to stage
#   EOF
#   )"

set -euo pipefail

log() {
    echo "[git-partial-commit] $*" >&2
}

error() {
    log "ERROR: $*"
    exit 1
}

# Check if we're in a git repository
if ! git rev-parse --git-dir &>/dev/null; then
    error "Not in a git repository"
fi

# Check arguments
if [ $# -lt 2 ]; then
    error "Usage: $0 <file> <patch>"
fi

FILE="$1"
PATCH="$2"

log "Staging partial changes for file: $FILE"

# Check if file exists
if [ ! -f "$FILE" ]; then
    error "File does not exist: $FILE"
fi

# Check if file has changes
if ! git diff --exit-code "$FILE" &>/dev/null; then
    log "File has unstaged changes"
elif ! git diff --cached --exit-code "$FILE" &>/dev/null; then
    log "File has staged changes"
else
    error "File has no changes: $FILE"
fi

# Validate patch is not empty
if [ -z "$PATCH" ]; then
    error "Patch cannot be empty"
fi

# Create a temporary file for the patch
PATCH_FILE=$(mktemp)
trap "rm -f '$PATCH_FILE'" EXIT

# Write patch to temporary file
echo "$PATCH" > "$PATCH_FILE"

log "Applying patch to staging area..."

# Apply the patch to staging area only (--cached)
# --unidiff-zero allows patches with zero context lines
# --whitespace=nowarn suppresses whitespace warnings
if git apply --cached --unidiff-zero --whitespace=nowarn "$PATCH_FILE" 2>&1; then
    log "Successfully staged partial changes"
    log "Use 'git diff --cached $FILE' to see staged changes"
    exit 0
else
    error "Failed to apply patch. Check that the patch format is correct and matches the current file state."
fi
