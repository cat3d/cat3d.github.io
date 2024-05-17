#!/bin/bash

# Ensure script halts on errors
set -e

# Check if an input folder is provided
if [ -z "$1" ]; then
  echo "Error: Please provide the path to the folder containing MP4 files."
  exit 1
fi

# Set the desired bitrate (adjust this value as needed)
BITRATE="600k"
CRF=30        # Constant Rate Factor (higher value means lower quality)

# Loop through each MP4 file in the folder
for file in "$1"/**/**/*.mp4; do
  # Extract filename without extension
  filename="${file%.*}"

  echo "Processing: $file"

  # Re-encode to WebM, set bitrate, scale down to max 720p, remove audio
  ffmpeg -i "$file" \
         -c:v libvpx-vp9 -b:v "$BITRATE" -crf "$CRF" \
         -pix_fmt yuv420p \
         -an "$filename.webm" \
         -y
done

echo "Conversion complete!"
