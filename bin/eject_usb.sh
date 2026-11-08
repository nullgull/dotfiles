#!/bin/bash

set -euo pipefail

if [[ -z "${USB_STICK_NAME:-}" ]]; then
    echo "❌ ERROR: USB_STICK_NAME env variable is not set"
    exit 1
fi

VOLUME="/Volumes/$USB_VOLUME_NAME"

if [[ ! -d "$VOLUME" ]]; then
    echo "❌ ERROR: $USB_VOLUME_NAME is not mounted"
    exit 1
fi

if diskutil eject "$VOLUME" > /dev/null; then
    echo "🪿🪿🪿 $USB_VOLUME_NAME safely ejected! 🪿🪿🪿"
else
    echo "❌ ERROR: Failed to eject $USB_VOLUME_NAME" >&2
    exit 1
fi