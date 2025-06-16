#!/bin/bash

if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it first."
    echo "On macOS: brew install imagemagick"
    echo "On Linux (Debian/Ubuntu): sudo apt-get install imagemagick"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <directory> [format: jpg|png] [quality: 1-100]"
    exit 1
fi

FORMAT="${2:-jpg}"
QUALITY="${3:-90}"

if [[ "$FORMAT" != "jpg" && "$FORMAT" != "png" ]]; then
    echo "Error: Invalid format. Use 'jpg' or 'png'."
    exit 1
fi

DIR="$1"
if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

echo "Converting HEIC files in '$DIR' to $FORMAT (quality: $QUALITY)..."
COUNT=0

for file in "$DIR"/*.heic "$DIR"/*.HEIC; do
    if [ -f "$file" ]; then
        filename=$(basename -- "$file")
        filename_noext="${filename%.*}"
        output_file="$DIR/$filename_noext.$FORMAT"

        convert "$file" -quality "$QUALITY" "$output_file"
        ((COUNT++))
        echo "Converted: $filename → $filename_noext.$FORMAT"
    fi
done

if [ "$COUNT" -eq 0 ]; then
    echo "No HEIC files found in '$DIR'."
else
    echo "Done! Converted $COUNT files."
fi
