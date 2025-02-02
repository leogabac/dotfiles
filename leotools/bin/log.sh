#!/bin/bash

# week_code() {
#   echo "$(date +%y)w$(date +%U)"
# }
#
week_code() {
  START_DAY="thursday"
  echo "$(date --date="last $START_DAY" +%y)w$(date --date="last $START_DAY" +%U)"
}

FILENAME="$(week_code).md"

cd ~/Dropbox/mnt/log/log25/ || exit

# Create the file if it does not exist
if [ ! -e "$FILENAME" ]; then
  touch $FILENAME
  echo "---" >> "$FILENAME"
  echo "title: \"$(week_code)\"" >> "$FILENAME"
  echo "author: \"leogabac\"" >> "$FILENAME"
  echo "date: \"$(date)\"" >> "$FILENAME"
  echo "toc: true" >> "$FILENAME"
  echo "---" >> "$FILENAME"
  echo "" >> "$FILENAME"
  echo "#$(week_code)" >> "$FILENAME"

fi

MARKDOWN=1 nvim $FILENAME

