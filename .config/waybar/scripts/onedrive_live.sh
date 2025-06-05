#!/usr/bin/env bash
# This script is used to display the status of the OneDrive sync service in Waybar.

# Open kitty with journalctl
kitty --class kitty -e journalctl --user-unit onedrive -f &

# Wait a moment for the window to be created
sleep 0.15

# Use batch command to modify the window with specific class and title
hyprctl --batch "dispatch togglefloating; dispatch resizeactive exact 2440 600; dispatch centerwindow"