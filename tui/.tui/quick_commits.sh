#!/bin/bash

# ===============================
# A simple TUI for commits
# ===============================

# NOTE: This depends on gum https://github.com/charmbracelet/gum

STATUS_FILES=$(echo . $(git status --short | cut -c4-))
FILES_TO_STAGE=$(gum choose --no-limit --header "Select files to stage" $STATUS_FILES)
MESSAGE=$(gum input --placeholder "Message for commit")

git add $FILES_TO_STAGE
printf "%s\n" "$(git status)"

echo "Press ENTER to continue"
read

if gum confirm "Commit changes?"; then
  git commit -m "$MESSAGE"
else
  git restore --staged $FILES_TO_STAGE
fi
