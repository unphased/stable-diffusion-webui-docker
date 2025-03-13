#!/bin/bash

# Takes N input video files and uses ffmpeg to:
# 1. Make a reversed version (') of each one.
# 2. Concatenate all 2*N videos into one in the sequence 0 + 0' + 1 + 1' and so on.

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 video1.mp4 video2.mp4 ..."
    exit 1
fi

OUTPUT_DIR="output"
REVERSED_DIR="reversed"
mkdir -p "$OUTPUT_DIR" "$REVERSED_DIR"

FILELIST="file_list.txt"
rm -rf "$FILELIST"  # Clear file list

for input in "$@"; do
    base_name=$(basename "$input" .mp4)
    reversed="$REVERSED_DIR/${base_name}_reversed.mp4"

    # Create reversed video
    echo "Reversing $input..."
    ffmpeg -i "$input" -vf reverse -preset veryslow -crf 19 "$reversed"

    # Append to list for concatenation
    echo "file '$input'" >> "$FILELIST"
    echo "file '$reversed'" >> "$FILELIST"
done

# Concatenate all videos
OUTPUT_VIDEO="$OUTPUT_DIR/final_output.mp4"
echo "Concatenating videos..."
ffmpeg -f concat -safe 0 -i "$FILELIST" -c copy "$OUTPUT_VIDEO"

echo "Done! Output saved as $OUTPUT_VIDEO"
