#!/bin/bash

source ~/.config/waybar/scripts/playerctl/utils.sh

process_title() {
    local title="$1"
    if [ -z "$title" ]; then
        printf "󰎇\n"
    else
        truncated_title=$(truncate_string "$title")
        escaped_title=$(escape_markup "$truncated_title")
        printf "%s\n" "$escaped_title"
    fi
}

title=$(playerctl metadata --format '{{title}}' 2>/dev/null)
process_title "$title"

playerctl --follow metadata --format '{{title}}' 2>/dev/null | while IFS= read -r title; do
    process_title "$title"
done
