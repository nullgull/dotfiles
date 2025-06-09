#!/usr/bin/env bash

source "$HOME/dotfiles/sketchybar/shared/utils.sh"

if [[ "$SENDER" == "mouse.clicked" ]]; then
	sketchybar --set current_space popup.drawing=toggle

	for sid in $(/opt/homebrew/bin/aerospace list-workspaces --all); do
		sketchybar --add item space_popup_$sid popup.current_space \
			--set space_popup_$sid \
				label="$sid" \
				icon="$(get_aerospace_icon $sid)" \
				topmost=true \
				padding_left=4 \
				padding_right=4 \
				background.corner_radius=5 \
				background.height=30 \
				background.color=0xff7048a4 \
				script="$HOME/dotfiles/sketchybar/plugins/aerospace_popup_click.sh $sid" \
			--subscribe space_popup_$sid mouse.clicked mouse.exited.global
	done
fi

current_workspace="$(/opt/homebrew/bin/aerospace list-workspaces --focused)"

sketchybar --set current_space label="$current_workspace" icon="$(get_aerospace_icon "$current_workspace")"