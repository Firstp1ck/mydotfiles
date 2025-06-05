#!/usr/bin/env bash

# Wechseln Sie zu Workspace 6
hyprctl dispatch workspace 6

# Battle.net starten
STEAM_COMPAT_CLIENT_INSTALL_PATH=$HOME/.steam/root WINEPREFIX=/mnt/SSD_NVME_4TB/Lutris/battlenet "$HOME"/.local/share/lutris/runners/proton/ge-proton/files/bin/wine "/mnt/SSD_NVME_4TB/Lutris/battlenet/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"

# # Starten Sie Lutris
# lutris &

# # Warten Sie kurz, damit Lutris vollständig gestartet ist
# sleep 1

# # Starten Sie die Anwendungen mit Lutris
# lutris lutris:rungame/battlenet
# lutris lutris:rungame/curseforge
# lutris lutris:rungame/tsmapp