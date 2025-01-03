#!/bin/bash

echo "$(pwd)"
# Check if the correct number of arguments is passed
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 input_image output_image dim"
  exit 1
fi

# Input and output file names
input_image=$1
output_image=$2
dim=$3

# Ensure ImageMagick is installed
if ! command -v magick &> /dev/null; then
  echo "Error: ImageMagick is not installed. Install it and try again."
  exit 1
fi

# Apply a semi-transparent black overlay to dim the image
# convert "$input_image" \( -size $(identify -format "%wx%h" "$input_image") xc:black \) -compose Multiply -composite "$output_image"

magick "$input_image" -modulate 90 "$output_image"  # Adjust brightness (80% here)
# magick "$input_image" -fill "rgba(0,0,0,$dim)" -draw 'rectangle 0,0,10000,10000' "$output_image"
magick "$output_image" -fill "rgba(0,0,0,$dim)" -draw 'rectangle 0,0,10000,10000' "$output_image"
echo "Dimmed image saved as $output_image"

