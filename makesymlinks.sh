#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="
zshrc*
gitignore
aerospace.toml
sketchybarrc|config/sketchybar/sketchybarrc
hammerspoon.lua|hammerspoon/init.lua
"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for entry in $files; do
  if [[ "$entry" == *"|"* ]]; then
    src_rel="${entry%%|*}"
    dst_rel="${entry##*|}"
  else
    src_rel="$(basename "$entry")"
    dst_rel="$entry"
  fi

  src="$dir/$src_rel"
  dst="$HOME/.$dst_rel"

	# Skip if symlink already points to the correct file
	if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
			echo "Already linked: $dst"
			continue
	fi

  echo "Moving any existing $dst to $olddir"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$olddir/$(dirname "$dst_rel")"
    mv "$dst" "$olddir/$(dirname "$dst_rel")/"
  fi

  echo "Creating symlink: $src → $dst"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
done

##########################
# Bootstrap LaunchAgents #
##########################
TEMPLATE="$HOME/dotfiles/launchagents/com.fswatch.plist.template"
RENDERED="$HOME/Library/LaunchAgents/com.dotfiles.fswatch.plist"
SCRIPT_PATH="$HOME/dotfiles/bin/watch_splice.sh"

# Make sure the script is executable
chmod +x "$SCRIPT_PATH"

# Create LaunchAgents folder if it doesn't exist
mkdir -p "$HOME/Library/LaunchAgents"

# Replace __SCRIPT_PATH__ with the actual path
sed "s|__SCRIPT_PATH__|$SCRIPT_PATH|" "$TEMPLATE" > "$RENDERED"

# Load (or reload) the launch agent
launchctl unload "$RENDERED" 2>/dev/null || true
launchctl load "$RENDERED"

echo "✅ fswatch launch agent installed and started."