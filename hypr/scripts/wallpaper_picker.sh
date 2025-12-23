#!/bin/bash

DIR="$HOME/Pictures/Wallpapers"
TMP_LIST=$(mktemp)

# Create the list of wallpapers with yad-compatible format
for img in "$DIR"/*.{jpg,png,jpeg}; do
    [ -f "$img" ] && echo "$img" >> "$TMP_LIST"
done

# Show thumbnails in a grid and get selection
SELECTED=$(yad --title="Pick a Wallpaper" \
    --image="$DIR/$(basename "$(head -n1 "$TMP_LIST")")" \
    --text="Select a wallpaper" \
    --form --field="Wallpapers:FL" "$(cat "$TMP_LIST" | tr '\n' '!')")

# Extract path and apply
if [ -n "$SELECTED" ]; then
    WALLPAPER=$(echo "$SELECTED" | cut -d '|' -f1)
    swww img "$WALLPAPER"
fi

rm "$TMP_LIST"



