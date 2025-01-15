#!/bin/bash

# week_code() {
#   echo "$(date +%y)w$(date +%U)"
# }
#
week_code() {
  START_DAY="wednesday"
  echo "$(date --date="last $START_DAY" +%y)w$(date --date="last $START_DAY" +%U)"
}

FILENAME="$(week_code).md"

cd ~/Dropbox/mnt/log/log25/ || exit

# Create the file if it does not exist
if [ ! -e "$FILENAME" ]; then
  touch $FILENAME
  echo "#$(week_code)" > "$FILENAME"

fi

MARKDOWN=1 nvim $FILENAME

