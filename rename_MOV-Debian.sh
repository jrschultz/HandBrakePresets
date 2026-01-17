#!/usr/bin/env bash
# This script renames Apple video files (*.MOV) using date from metadata.

if ! command -v exiftool >/dev/null 2>&1; then
    echo "exiftool is required. On Debian/Ubuntu: sudo apt install libimage-exiftool-perl"
    exit 1
fi

shopt -s nullglob    # prevents the for loop running once with literal "*.MOV"

for file in *.MOV; do
    # Get creation date (try most common QuickTime tags, treat as UTC → local)
    datetime=$(exiftool -CreateDate -d "%Y%m%d_%H%M%S" -api QuickTimeUTC "$file" 2>/dev/null \
               | awk -F': ' '{print $2}' || echo "")

    if [ -z "$datetime" ]; then
        echo "Could not read usable date from $file, skipping..."
        continue
    fi

    newname="${datetime}.MOV"

    if [ -e "$newname" ]; then
        echo "Target $newname already exists, skipping $file..."
        continue
    fi

    mv -v -- "$file" "$newname"
done

echo "Renaming complete!"
