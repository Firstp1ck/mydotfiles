#!/usr/bin/env bash

# Check if alsamixer is running
if ! pgrep -x "alsamixer" > /dev/null; then
    # Start alsamixer in a new terminal
    kitty -e alsamixer &
    
    # Wait for the window to appear
    sleep 0.2
    
    # Set window properties
    hyprctl --batch "dispatch togglefloating; dispatch resizeactive exact 70% 55%; dispatch centerwindow"
fi

# After alsamixer is closed, save the settings
if sudo -n true 2>/dev/null; then
    # If sudo is available without password, use it
    sudo alsactl store
else
    # If sudo requires password, use pkexec instead
    pkexec alsactl store
fi