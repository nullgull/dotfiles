#!/usr/bin/env bash

DIR="$HOME/Pictures/screenshots"

echo "[+] Configuring screenshots..."

# Create screenshot dir
if ! mkdir -p "$DIR"; then
    echo "[✗] Failed to create screenshot directory: $DIR"
    exit 1
fi

# Set screenshot location
if ! defaults write com.apple.screencapture location "$DIR"; then
    echo "[✗] Failed to set screenshot location"
    exit 1
fi

# TODO: move this to a separate script that restarts mac upon completion
# Apply changes
killall SystemUIServer >/dev/null 2>&1

echo "[✓] Screenshots configured"