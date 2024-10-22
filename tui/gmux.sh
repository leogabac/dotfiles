#!/bin/bash

# ===============================
# A simple TUI for tmux
# ===============================

# NOTE: This depends on gum https://github.com/charmbracelet/gum

SELECTION=$(gum choose --header "Select tmux action" "target attach" "new session")

case "$SELECTION" in
  "target attach")
    ALL_SESSIONS=$(tmux list-sessions -F "#S")
    SESSION_NAME=$(gum choose --header "Select a session:" $ALL_SESSIONS)
    tmux attach -t $SESSION_NAME
  ;;
  "new session")
    SESSION_NAME=$(gum input --placeholder "Name of new tmux session")
    tmux new-session -s $SESSION_NAME
  ;;
esac

