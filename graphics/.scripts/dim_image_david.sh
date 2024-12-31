#!/bin/bash

echo "$(pwd)"
# Check if the correct number of arguments is passed
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 input_image output_image dim color"
  exit 1
fi

# Input and output file names
input_image=$1
output_image=$2
dim=$3
color=$4

# Ensure ImageMagick is installed
if ! command -v magick &>/dev/null; then
  echo "Error: ImageMagick is not installed. Install it and try again."
  exit 1
fi

# Extract the dimensions of the input image
dimensions=$(magick identify -format "%wx%h" "$input_image")

# Create a solid color background
echo "The solid background is created..."
magick -size "$dimensions" "xc:rgb($color)" aux0.png

# Adjust the opacity of the input image to dim it
echo "The image's opacity is set to $dim..."
magick $input_image aux1.png
magick aux1.png -alpha set -channel A -evaluate multiply $dim aux2.png

# Overlay the input image on top of the solid color background
echo "The final image is created..."
magick aux0.png aux2.png -compose Over -composite "$output_image"

# Clean up the temporary background file
echo "Auxilary files are deleted..."
rm aux0.png aux1.png aux2.png

echo "Image overlaid on solid color saved as $output_image"
