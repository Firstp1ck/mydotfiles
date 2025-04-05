#!/bin/bash

# Wechseln Sie zu Workspace 6
hyprctl dispatch workspace 6

# Starten Sie Lutris
lutris &

# Warten Sie kurz, damit Lutris vollständig gestartet ist
sleep 1

# Starten Sie die Anwendungen mit Lutris
lutris lutris:rungame/battlenet
lutris lutris:rungame/curseforge
lutris lutris:rungame/tsmapp