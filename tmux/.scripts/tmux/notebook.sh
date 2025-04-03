#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: ./tmux_run_command.sh <environment-alias>"
    exit 1
fi

ENV_ALIAS="$1"
POST_COMMAND="jupyter notebook --no-browser"

SESSION_NAME="${ENV_ALIAS} notebook"
WORK_DIR="$HOME"

# Check if the tmux session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
else
    echo "Creating new session '$SESSION_NAME'..."
    # Create a new tmux session and run the commands
    tmux new-session -d -s "$SESSION_NAME"
    tmux send-keys -t "$SESSION_NAME" "cd $WORK_DIR && clear && $ENV_ALIAS && $POST_COMMAND" Enter
    tmux attach-session -t "$SESSION_NAME"
fi
i
