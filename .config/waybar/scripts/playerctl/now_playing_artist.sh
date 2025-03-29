#!/bin/bash

source ~/.config/waybar/scripts/playerctl/utils.sh

process_artist() {
    local artist="$1"
    if [ -z "$artist" ]; then
        printf "YourCoffee\n"
    else
        truncated_artist=$(truncate_string "$artist")
        escaped_artist=$(escape_markup "$truncated_artist")
        printf "%s\n" "$escaped_artist"
    fi
}

artist=$(playerctl metadata --format '{{artist}}' 2>/dev/null)
process_artist "$artist"

playerctl --follow metadata --format '{{artist}}' 2>/dev/null | while IFS= read -r artist; do
    process_artist "$artist"
done
