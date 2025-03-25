#!/bin/bash

set -e

DEST_DIR="$HOME/Splice/sounds"
SRC_DIR="$DEST_DIR/packs"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "sounds directory does not exist: $SRC_DIR"
  exit 1
fi

DATE_PREFIX=$(date +"%d%m%y")

get_next_seq() {
  local max_seq=-1
  while IFS= read -r existing_file; do
    filename=$(basename "$existing_file")
    if [[ $filename =~ ^${DATE_PREFIX}_([0-9]{2})_ ]]; then
      seq=${BASH_REMATCH[1]}
      (( seq > max_seq )) && max_seq=$seq
    fi
  done < <(find "$DEST_DIR" -type f -name "${DATE_PREFIX}_??_*")

  printf "%02d" $((max_seq + 1))
}

find "$SRC_DIR" -type f -print0 | while IFS= read -r -d '' file; do
  [[ "${file##*/}" == ".DS_Store" ]] && continue

  base_name=$(basename "$file")
  seq=$(get_next_seq)
  new_name="${DATE_PREFIX}_${seq}_$base_name"

  mv "$file" "$DEST_DIR/$new_name"
  echo "Moved: $base_name → $new_name"
done

rm -rf "$SRC_DIR"
echo "All files moved and $SRC_DIR deleted."