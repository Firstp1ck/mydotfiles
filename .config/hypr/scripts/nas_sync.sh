#!/usr/bin/env bash

NAS_IP="192.168.1.126"
NAS_PORT=9222
NAS_USER="Firstpick"
ONEDRIVE_SOURCE="/mnt/SSD_NVME_4TB/Onedrive/"
NAS_DEST="/Volume1/public/Onedrive"

sync_arch_to_nas() {
    echo "=== Syncing Arch Onedrive to NAS ==="
    local nas_password_file="$HOME/.local/nas_credentials"
    local nas_password=""

    # Function to read password from file
    read_password() {
        if [ ! -f "$nas_password_file" ]; then
            echo "Error: Password file not found at: $nas_password_file"
            return 1
        fi
        
        # Check file permissions
        local file_perms
        file_perms=$(stat -c "%a" "$nas_password_file")
        if [ "$file_perms" != "600" ]; then
            echo "Warning: Insecure file permissions on password file. Fixing..."
            chmod 600 "$nas_password_file"
        fi
        
        # Read password from file
        nas_password=$(cat "$nas_password_file")
        if [ -z "$nas_password" ]; then
            echo "Error: Password file is empty"
            return 1
        fi
        return 0
    }

    # Check if rsync is installed
    if ! command -v rsync &>/dev/null; then
        echo "rsync not found. Installing..."
        if ! sudo pacman -S --noconfirm rsync; then
            echo "Error: Failed to install rsync"
            return 1
        fi
    fi

    # Check for SSH key, create if missing
    if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
        echo "SSH key not found. Generating one..."
        if ! ssh-keygen -t ed25519 -N "" -f "$HOME/.ssh/id_ed25519"; then
            echo "Error: SSH keygen failed"
            return 1
        fi
    fi

    # Run rsync to sync the directory
    echo "Starting rsync..."
        
    # Read password from file
    if ! read_password; then
        return 1
    fi

    # Install sshpass if needed
    if ! command -v sshpass &>/dev/null; then
        echo "sshpass not found. Installing..."
        if ! sudo pacman -S --noconfirm sshpass; then
            echo "Error: Failed to install sshpass"
            return 1
        fi
    fi

    if sshpass -p "$nas_password" rsync -avz --delete -e "ssh -p $NAS_PORT" "$ONEDRIVE_SOURCE" "$NAS_USER@$NAS_IP:$NAS_DEST"; then
        echo "Sync completed successfully."
        date '+%Y-%m-%d %H:%M:%S' > /tmp/rsync_success
    else
        echo "Error: Sync failed."
        nas_password=""  # Clear password
        return 1
    fi

    # Clear the password variable for security
    nas_password=""
}

# Main script execution
sync_arch_to_nas
if [ $? -eq 0 ]; then
    echo "Sync to NAS completed successfully."
else
    echo "Sync to NAS failed."
fi