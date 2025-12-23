#!/bin/bash

# Config and Path
WALLPAPERS="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-picker"
THUMB_WIDTH="250"
THUMB_HEIGHT="141"

# Make the thumb dir if it's not exist
mkdir -p "$CACHE_DIR"

# Generate thumbnail
generate_thumbnail(){
    local input="$1"
    local output="$2"
    magick "$input" -thumbnail "${THUMB_WIDTH}x${THUMB_HEIGHT}^" \
        -gravity center -extent "${THUMB_WIDTH}x${THUMB_HEIGHT}" "$output"
}

# Generate menu with thumbnails
generate_menu(){
    # Find all images and sort naturally
    while IFS= read -r img; do
        [[ -f "$img" ]] || continue
        thumb="$CACHE_DIR/$(basename "${img%.*}")"

        # Generate thumbnail if missing or outdated
        if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
            generate_thumbnail "$img" "$thumb"
        fi

        # Output for wofi
        echo -en "img:$thumb\x00info:$(basename "$img")\x1f$img\n"
    done < <(find "$WALLPAPERS" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort -V)
}


# Run wofi with thumbnails
CHOICE=$(generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=${THUMB_WIDTH}x${THUMB_HEIGHT}" \
    --columns 4 \
    --allow-images \
    --insensitive \
    --sort-order=default \
    --prompt "Select Wallpaper" \
    --conf ~/.config/wofi/wallpaper
)

[ -z "$CHOICE" ] && exit 0
WAL_NAME=$(basename "$CHOICE")
SELECTED="$WALLPAPERS/$WAL_NAME"

# Extract THEME name
BASENAME=$(basename "$SELECTED")
THEME="${BASENAME%%_*}"

echo $SELECTED
swww img "${SELECTED}".* --transition-step 100 --transition-type wipe --transition-angle 30
