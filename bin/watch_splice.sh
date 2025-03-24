#!/bin/bash

WATCH_PARENT="$HOME/Splice/sounds"
SOURCE_NAME="packs"
CLEAN_SCRIPT="$HOME/dotfiles/bin/clean_splice.sh"

/opt/homebrew/bin/fswatch -0 "$WATCH_PARENT" | while IFS= read -r -d '' event; do
  # Check if the sounds dir was created
  if [[ -d "$WATCH_PARENT/$SOURCE_NAME" ]]; then
    echo "Detected creation of $SOURCE_NAME — running move script..."
    "$CLEAN_SCRIPT"
  fi
done
