#!/bin/bash
# Script converts cell phone camera footage to constant frame rates for editing
#
# Directory containing video files (default: current directory)
INPUT_DIR="."
# Output directory for converted files
OUTPUT_DIR="./converted"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Supported video file extensions
EXTENSIONS=("*.mp4" "*.MOV" "*.avi" "*.mkv" "*.flv" "*.wmv")

# Loop through all video files in the input directory
for ext in "${EXTENSIONS[@]}"; do
  for file in "$INPUT_DIR"/$ext; do
    if [[ -f "$file" ]]; then
      # Get the filename without path and extension
      filename=$(basename "$file")
      filename_noext="${filename%.*}"
      
      # Output file path
      output_file="$OUTPUT_DIR/${filename_noext}_cfr30.mp4"
      
      echo "Converting $file to 30 fps CFR..."
      
      # FFmpeg command to convert to CFR 30 fps
      ffmpeg -i "$file" -r 30 -c:v libx264 -crf 18 -c:a aac -b:a 192k "$output_file"
      
      if [[ $? -eq 0 ]]; then
        echo "Successfully converted $file to $output_file"
      else
        echo "Error converting $file"
      fi
    fi
  done
done

echo "Conversion complete! Converted files are in $OUTPUT_DIR"
