#!/bin/bash

SESSION_NAME='thesis'
WORK_DIR="~/Dropbox/mnt/thesis/"

# Check if the tmux session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
else
    echo "Creating new session '$SESSION_NAME'..."
    # Create a new tmux session and run the commands
    tmux new-session -d -s "$SESSION_NAME"
    tmux send-keys -t "$SESSION_NAME" "cd $WORK_DIR && clear && nvim main.tex" Enter
    tmux attach-session -t "$SESSION_NAME"
fi
