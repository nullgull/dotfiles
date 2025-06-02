#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="zshrc aerospace.toml gitignore config/sketchybar/sketchybarrc"    # list of files/folders to symlink in homedir

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
for file in $files; do
	echo "Moving any existing dotfiles from ~ to $olddir"
	if [ -e ~/.$file ] || [ -L ~/.$file ]; then
		mv ~/.$file $olddir/
	fi

	cleaned=$(basename "$file")

	echo "Creating symlink: ~/dotfiles/$cleaned → ~/.$file"
	mkdir -p "$(dirname ~/.$file)"
	ln -sf $dir/$cleaned ~/.$file
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