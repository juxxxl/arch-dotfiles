#!/bin/bash

# Set some variables
wall_dir="${HOME}/Pictures/Wallpapers"
cacheDir="${HOME}/.cache/jp/${theme}"
rofi_command="rofi -dmenu -theme ${HOME}/.config/rofi/wallSelect.rasi -theme-str ${rofi_override}"

# Create cache dir if not exists
if [ ! -d "${cacheDir}" ]; then
    mkdir -p "${cacheDir}"
fi

# Define monitor size and resolution settings
physical_monitor_size=24
monitor_res=$(hyprctl monitors | grep -A2 Monitor | head -n 2 | awk '{print $1}' | grep -oE '^[0-9]+')
dotsperinch=$(echo "scale=2; $monitor_res / $physical_monitor_size" | bc | xargs printf "%.0f")
monitor_res=$(( $monitor_res * $physical_monitor_size / $dotsperinch ))

rofi_override="element-icon{size:${monitor_res}px;border-radius:0px;}"

# Generate thumbnails for all images in the wallpaper directory and subdirectories
find "$wall_dir" -type f -regex ".*\.\(jpg\|jpeg\|png\|webp\)" | while read -r imagen; do
    relative_path="${imagen#$wall_dir/}"
    cache_subdir="${cacheDir}/$(dirname "$relative_path")"
    mkdir -p "$cache_subdir"
    thumbnail_path="${cache_subdir}/$(basename "$imagen")"
    if [ ! -f "$thumbnail_path" ]; then
        convert -strip "$imagen" -thumbnail 500x500^ -gravity center -extent 500x500 "$thumbnail_path"
    fi
done

# # Convert images in directory and save to cache dir
# for imagen in "$wall_dir"/*.{jpg,jpeg,png,webp}; do
#     if [ -f "$imagen" ]; then
#         nombre_archivo=$(basename "$imagen")
#         if [ ! -f "${cacheDir}/${nombre_archivo}" ]; then
#             convert -strip "$imagen" -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${nombre_archivo}"
#         fi
#     fi
# done

# Function to list wallpapers and directories, sorted alphabetically, excluding the current directory
list_wallpapers() {
    # Add parent directory option if we're in a subdirectory
    if [ "$current_dir" != "$wall_dir" ]; then
        echo -en "../\x00icon\x1ffolder\n"
    fi
    
    # List files and directories, sorted alphabetically
    find "$current_dir" -maxdepth 1 -not -path "$current_dir" | sort | while read -r path; do
        name=$(basename "$path")
        if [ -d "$path" ]; then
            echo -en "$name/\x00icon\x1ffolder\n"
        elif [[ "$name" =~ \.(jpg|jpeg|png|webp)$ ]]; then
            echo -en "$name\x00icon\x1f${cacheDir}/${current_dir#$wall_dir/}/$name\n"
        fi
    done
}

# Initialize current directory
current_dir="$wall_dir"

# Handle navigation through folders
while true; do
    # Select a picture or folder with rofi
    wall_selection=$(list_wallpapers | $rofi_command)
    
    # Exit if nothing selected
    [[ -n "$wall_selection" ]] || exit 1
    
    # Handle parent directory navigation
    if [[ "$wall_selection" == "../" ]]; then
        current_dir=$(dirname "$current_dir")
        continue
    fi
    
    # Handle folder selection
    if [[ "$wall_selection" == */ ]]; then
        wall_selection="${wall_selection%/}"  # Remove trailing slash
        current_dir="${current_dir}/${wall_selection}"
        continue
    fi
    
    # If we get here, a file was selected
    break
done

# Set the wallpaper
selected_file="${current_dir}/${wall_selection}"
swww img "$selected_file" --transition-step 100 --transition-type wipe --transition-angle 30 --transition-duration 2 --transition-fps 144
