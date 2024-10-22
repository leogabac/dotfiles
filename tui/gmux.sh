#!/bin/bash

# ===============================
# A simple TUI for tmux
# ===============================

# NOTE: This depends on gum https://github.com/charmbracelet/gum

election=$(gum choose --header "Select tmux action" "target attach" "new session")

case "$election" in
  "target attach")
    all_sessions=$(tmux list-sessions -F "#S")
    session_name=$(gum choose --header "Select a session:" $all_sessions)
    tmux attach -t $session_name
  ;;
  "new session")
    session_name=$(gum input --placeholder "Name of new tmux session")
    tmux new-session -s $session_name
  ;;
esac

