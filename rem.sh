#!/bin/bash

# Define the target folder
TARGET_DIR="/home/k/Ilayaraja"

# Step 1: Unzip all the zip files in the target directory
echo "Unzipping files..."
find "$TARGET_DIR" -type f -name "*.zip" | while read -r zip_file; do
    unzip "$zip_file" -d "${zip_file%.zip}" || echo "Failed to unzip: $zip_file"
done

# Step 2: Rename the extracted folders by removing unwanted parts in the folder name
echo "Renaming extracted folders..."
find "$TARGET_DIR" -type d -name "*-320kbps-MassTamilan*" | while read -r folder; do
    # Remove the unwanted part '-320kbps-MassTamilan'
    new_folder_name=$(echo "$folder" | sed -E 's/-320kbps-MassTamilan[^/]*//g')
    mv "$folder" "$new_folder_name" || echo "Failed to rename: $folder"
done

# Step 3: Modify the ID3 tags for each MP3 file
echo "Modifying ID3 tags..."
find "$TARGET_DIR" -type f -name "*.mp3" | while read -r file; do
    # Get the album (immediate folder name) and artist (superfolder name)
    ALBUM=$(basename "$(dirname "$file")")
    ARTIST=$(basename "$(dirname "$(dirname "$file")")")  # The superfolder name

    # Get the title from the filename, cleaning up '-MassTamilan' and other parts
    TITLE=$(basename "$file" | sed -E 's/ -?MassTamilan[^.]*//g' | sed 's/.mp3//')

    # Extract the year from the folder or file name if possible (or leave it empty if not found)
    YEAR=$(echo "$ALBUM" | grep -o '[0-9]\{4\}')

    # Debugging output to verify paths and tags
    echo "Processing: $file"
    echo "Setting Artist: $ARTIST"
    echo "Setting Album: $ALBUM"
    echo "Setting Title: $TITLE"
    echo "Setting Year: $YEAR"

    # Step 1: Delete existing ID3 tags
    id3v2 -D "$file" || echo "Failed to delete tags: $file"

    # Step 2: Set new ID3 tags (Title, Artist, Album, Year)
    id3v2 --TIT2 "$TITLE" --TPE1 "$ARTIST" --TALB "$ALBUM" --TYER "$YEAR" "$file" || echo "Failed to set tags: $file"
done

echo "All steps completed successfully."


