# Dotfiles

My personal dotfiles for a Hyprland-based Linux desktop environment, featuring a modern and minimalist aesthetic.

## Table of Contents
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
  - [Base Requirements](#base-requirements)
  - [KDE Dependencies](#kde-dependencies)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Stow Installation](#stow-installation)
- [Configuration](#configuration)
  - [Monitor Setup](#monitor-setup)
  - [Wallpaper Configuration](#wallpaper-configuration)
  - [Hyprland Configuration](#hyprland-configuration)
  - [Log Locations](#log-locations)
- [Updates](#updates)
- [Contributing](#contributing)
- [License](#license)

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/Firstp1ck/.dotfiles.git ~/.dotfiles
```

2. Use GNU Stow to create symlinks:
```bash
cd ~/.dotfiles
stow .
# If Conflicts are present:
./.local/scripts/Start_stow_solve.sh
```

## Prerequisites

### Base Requirements
- Arch Linux or compatible distribution
- Wayland-compatible GPU drivers
- Base development tools:
  ```bash
  sudo pacman -S base-devel git curl wget stow
  ```

### KDE Dependencies
```bash
sudo pacman -S sddm plasma kde-applications xorg plasma-desktop plasma-wayland-session
```

## Installation

### Dependencies

```bash
# Window Management
sudo pacman -S hyprland hyprpaper waybar wofi dunst

# Development Tools
sudo pacman -S kitty fish neovim github-cli

# System Utilities
sudo pacman -S dolphin

# Additional Dependencies
sudo pacman -S qt5-wayland qt6-wayland xdg-desktop-portal-hyprland
```

### Stow Installation
 
```bash
./.local/scripts/Start_stow_solve.sh # Backup existing configs and uses stow
```

## Configuration

Before starting Hyprland, ensure the following configurations are properly set:

### Monitor Setup
1. Check available monitors:
```bash
hyprctl monitors
```

2. Identify the primary monitor and its resolution.

3. Check and edit `.config/hypr/monitors.conf`:
```bash
vim ~/.config/hypr/monitors.conf
```
4. Update monitor settings in `.config/hypr/sources/change_wallpaper.conf`:
- Modify `MONITORS` variable to match your setup

### Wallpaper Configuration
1. Check wallpaper paths:
- In `hyprlock.conf`: Verify wallpaper path exists
- In `sources/app_variables.conf`: Update `$wallpaper` variable
- In `sources/change_wallpaper.conf`: Verify `WALLPAPER_DIR` path

2. Ensure wallpaper directory exists and contains images:
```bash
mkdir -p ~/Pictures/wallpapers
```

### Hyprland Configuration
- Window management settings in `.config/hypr/sources/look_and_feel.conf`
- Keybindings in `.config/hypr/sources/binds.conf`
- Autostart applications in `.config/hypr/sources/autostart.conf`

### Log Locations
- Hyprland: `~/.local/share/hyprland/`
- System: `journalctl -xe`

## Updates

To update the dotfiles:

```bash
cd ~/.dotfiles
git pull
stow -R .  # Restow to update symlinks
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.