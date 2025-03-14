#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    # if i pass an argument i want to search within that directory
    current_dir=$1
    selected=$(find $current_dir -mindepth 1 -maxdepth 3 -type d | fzf)
else
    selected=$(find ~/ ~/Documents/ ~/Documents/projects ~/Dropbox/ ~/Dropbox/mnt/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

cd $selected
