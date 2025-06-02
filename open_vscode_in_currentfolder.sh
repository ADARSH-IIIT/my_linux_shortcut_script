#!/bin/bash

# Get active window ID
win_id=$(xdotool getactivewindow)

# Get PID of that window
pid=$(xprop -id "$win_id" _NET_WM_PID | awk '{print $3}')

# Get process name
proc_name=$(ps -p "$pid" -o comm=)

if [[ "$proc_name" != "nemo" && "$proc_name" != "nemo-desktop" ]]; then
    echo "❌ Not a Nemo window. Got: $proc_name"
    notify-send "VSCode Launcher" "Not a file manager window."
    exit 1
fi

# Get the window title (e.g., "Pictures — /home/acid/Pictures" or "Home")
win_title=$(xprop -id "$win_id" WM_NAME | cut -d '"' -f 2)

# Determine folder path
if [[ "$win_title" == "Home" ]]; then
    folder="$HOME"
else
    folder=$(echo "$win_title" | grep -oE '/.*' | xargs)
fi

# Launch VSCode if the path exists
if [[ -d "$folder" ]]; then
    echo "✅ Launching VSCode in: $folder"
    code "$folder"
else
    echo "❌ Could not determine full path from title: $win_title"
    notify-send "VSCode Launcher" "Could not resolve full path from window title."
fi

