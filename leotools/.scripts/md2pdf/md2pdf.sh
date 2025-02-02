#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.md output.pdf"
    exit 1
fi

INPUT_MD="$1"
OUTPUT_PDF="$2"

# Convert Markdown to PDF with specified options
# --listings \
# -H ~/.scripts/md2pdf/listings_setup.tex \
# pandoc "$INPUT_MD" -o "$OUTPUT_PDF" --pdf-engine=xelatex \
#     -H ~/.scripts/md2pdf/head.tex \
#     -V colorlinks=true -V urlcolor=NavyBlue -V toccolor=red \
#     --table-of-contents \
#     --number-sections \
#     --highlight-style ~/.scripts/md2pdf/highlights.theme \
#
pandoc "$INPUT_MD" -o "$OUTPUT_PDF" --from markdown \
    --template eisvogel \
    --listings \
    --number-sections \
    -V colorlinks=true -V urlcolor=NavyBlue \

echo "Conversion complete: $OUTPUT_PDF"
