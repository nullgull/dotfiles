#!/usr/bin/env bash

if [[ "$SENDER" == "mouse.clicked" ]]; then
  /opt/homebrew/bin/aerospace workspace "${NAME#space_popup_}"
fi

sketchybar --set current_space popup.drawing=off
