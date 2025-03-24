#!/bin/bash

set -e

DEST_DIR="$HOME/Splice/sounds"
SRC_DIR="$DEST_DIR/packs"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "sounds directory does not exist: $SRC_DIR"
  exit 1
fi

find "$SRC_DIR" -type f -print0 | while IFS= read -r -d '' file; do
  base_name=$(basename "$file")

  # Skip moving if file already exists in destination
  if [[ -e "$DEST_DIR/$base_name" ]]; then
    echo "Skipping $base_name (already exists in $DEST_DIR)"
    continue
  fi

  mv "$file" "$DEST_DIR/$base_name"
done

# Delete the sounds directory after moving
rm -rf "$SRC_DIR"

echo "All files moved (if not already present), and $SRC_DIR deleted."