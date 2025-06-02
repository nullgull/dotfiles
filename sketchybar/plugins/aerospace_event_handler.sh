#!/usr/bin/env bash

if [[ "$SENDER" == "mouse.clicked" ]]; then
	sketchybar --set current_space popup.drawing=toggle

	for sid in $(/opt/homebrew/bin/aerospace list-workspaces --all); do
		sketchybar --add item space_popup_$sid popup.current_space \
			--set space_popup_$sid \
				label="$sid" \
				topmost=true \
				padding_left=8 \
				padding_right=8 \
				background.corner_radius=4 \
				background.height=30 \
				background.color=0x66ffffff \
				script="$HOME/dotfiles/sketchybar/plugins/aerospace_popup_click.sh $sid" \
			--subscribe space_popup_$sid mouse.clicked mouse.exited.global
	done
fi

label=$(/opt/homebrew/bin/aerospace list-workspaces --focused)

sketchybar --set current_space label="$label"
