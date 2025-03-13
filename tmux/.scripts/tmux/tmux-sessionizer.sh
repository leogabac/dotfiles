#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ ~/Documents/ ~/Documents/projects ~/Dropbox/ ~/Dropbox/mnt/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

# Check if the session already exists
if tmux has-session -t="$selected_name" 2>/dev/null; then
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
    fi
    exit 0
fi

# Create a new session if it does not exist
tmux new-session -ds "$selected_name" -c "$selected"

# Attach or switch to the session
if [[ -z $TMUX ]]; then
    tmux attach-session -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi

