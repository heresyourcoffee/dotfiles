#!/bin/bash

# Function to calculate relative time correctly
relative_time() {
    local timestamp=$1  # microseconds since boot
    
    # Get system uptime in microseconds
    local uptime_micro=$(awk '{print $1 * 1000000}' /proc/uptime)
    
    # Calculate when the notification occurred (microseconds since boot)
    local notification_micro=$((uptime_micro - timestamp))
    
    # Convert to seconds for human-readable format
    local notification_sec=$((notification_micro / 1000000))
    
    if [ $notification_sec -lt 60 ]; then
        echo "just now"
    elif [ $notification_sec -lt 3600 ]; then
        local minutes=$((notification_sec / 60))
        echo "$minutes minute$([ $minutes -ne 1 ] && echo s) ago"
    elif [ $notification_sec -lt 86400 ]; then
        local hours=$((notification_sec / 3600))
        echo "$hours hour$([ $hours -ne 1 ] && echo s) ago"
    else
        local days=$((notification_sec / 86400))
        echo "$days day$([ $days -ne 1 ] && echo s) ago"
    fi
}

# Function to remove HTML tags
remove_html_tags() {
    echo "$1" | sed -e 's/<[^>]*>//g'
}

# Get dunst history
notifications=$(dunstctl history | jq -r '.data[0][] | [.appname.data, .summary.data, .body.data, .timestamp.data, .icon_path.data] | @tsv' 2>/dev/null)

if [ -z "$notifications" ]; then
    echo "No notification history found or jq is not installed."
    exit 1
fi

# Process notifications
processed_notifications=$(echo "$notifications" | while IFS=$'\t' read -r app summary body timestamp icon; do
    relative=$(relative_time "$timestamp")
    clean_summary=$(remove_html_tags "$summary")
    clean_body=$(remove_html_tags "$body")
    printf "%s\t%s\t%s\t%s\t%s\n" "$app" "$clean_summary" "$clean_body" "$relative" "$icon"
done)

# Display with fzf
selected=$(echo "$processed_notifications" | fzf --delimiter='\t' \
    --preview='echo -e "App: {1}\nSummary: {2}\nBody: {3}\nWhen: {4}\nIcon: {5}"' \
    --preview-window=wrap \
    --with-nth=1,2,3,4)

if [ -n "$selected" ]; then
    IFS=$'\t' read -r app summary body relative icon <<< "$selected"
    
    echo -e "\nFull Notification Details:"
    echo "App: $app"
    echo "Summary: $summary"
    echo "Body: $body"
    echo "When: $relative"
    if [ -n "$icon" ]; then
        echo "Icon: $icon"
        if [ -f "$icon" ]; then
            echo "Icon preview:"
            kitty +kitten icat "$icon" 2>/dev/null || echo "(No preview available)"
        fi
    fi
fi
