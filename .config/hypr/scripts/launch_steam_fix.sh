#!/usr/bin/env bash

# Set up logging
LOG_FILE="$HOME/.local/share/steam_launch.log"
TIMESTAMP() {
    date "+%Y-%m-%d %H:%M:%S"
}

log_message() {
    echo "[$(TIMESTAMP)] $1" >> "$LOG_FILE"
}

# Create log file if it doesn't exist
touch "$LOG_FILE"

is_steam_running() {
    pgrep -x steam >/dev/null
}

max_attempts=3
attempt=1

log_message "Starting Steam launch attempt"

while [ $attempt -le $max_attempts ]; do
    if ! is_steam_running; then
        log_message "Attempt $attempt: Steam not running, launching..."
        gtk-launch steam.desktop
        sleep 2  # Give Steam time to start
        
        if is_steam_running; then
            log_message "Attempt $attempt: Steam successfully launched"
            exit 0
        else
            log_message "Attempt $attempt: Steam failed to start"
        fi
    else
        log_message "Steam already running"
        exit 0
    fi
    attempt=$((attempt + 1))
done

# If we get here, Steam failed to start after all attempts
log_message "Failed to launch Steam after $max_attempts attempts"
exit 1