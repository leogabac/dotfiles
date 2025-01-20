#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.md output.pdf"
    exit 1
fi

INPUT_MD="$1"
OUTPUT_PDF="$2"

# Convert Markdown to PDF with specified options
pandoc "$INPUT_MD" -o "$OUTPUT_PDF" --pdf-engine=xelatex --highlight-style=breezedark \
    -V geometry:margin=1in \
    -V colorlinks=true -V urlcolor=blue \
    -V listings


echo "Conversion complete: $OUTPUT_PDF"
