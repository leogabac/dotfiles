#!/bin/bash

# List all PDFs in the current directory
pdf_files=($(ls *.pdf))

# Check if there are PDF files in the directory
if [ ${#pdf_files[@]} -eq 0 ]; then
  echo "No PDF files found in the directory."
  exit 1
fi

# Use gum to let the user select multiple PDFs
#

options=("None" "${pdf_files[@]}")
selected_pdfs=()
while true; do
  # Display the list of PDF files and add "None" option at the top
  selected_pdf=$(gum choose "${options[@]}" --header "Select PDFs or choose 'None' to finish")

  # Check if the user selected 'None' to exit the loop
  if [ "$selected_pdf" == "None" ]; then
    break
  fi

  # Append the selected PDF to the array
  selected_pdfs+=("$selected_pdf")
done

# selected_pdfs=$(gum choose "${pdf_files[@]}" --no-limit --header "Select PDFs to merge")

# Check if user selected any PDFs
if [ -z "$selected_pdfs" ]; then
  echo "No PDFs selected. Exiting."
  exit 1
fi

# Create a temporary file to store the selected PDFs in the right order
temp_file=$(mktemp)

# Split the selected PDFs into an array
IFS=$'\n' read -r -d '' -a selected_pdfs_array <<< "${selected_pdfs[@]}"

# Write each selected PDF filename into the temporary file
for pdf in "${selected_pdfs_array[@]}"; do
  echo "$pdf" >> "$temp_file"
done

# Merge the PDFs using pdftk
output_pdf=$(gum input --placeholder "PDF name (with .pdf)")
pdftk $(cat "$temp_file") cat output "$output_pdf"

# Clean up
rm "$temp_file"

echo "PDFs merged successfully into $output_pdf"
