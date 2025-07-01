#!/bin/bash

PRESET_TEMPS=(4000 4500 5000 5500 6000)
ROFI_MENU=$(printf "%s\n" "Custom" "${PRESET_TEMPS[@]}")
SELECTED=$(echo "$ROFI_MENU" | rofi -dmenu -p "🌡️ Temp:" -theme-str 'listview { lines: 6; }')

case "$SELECTED" in
    "Custom")
	TEMP=$(rofi -dmenu -p "🌡️ Temp:" -l 0 -theme-str 'entry { placeholder: "'" 1000 - 10000"'"; }')
        ;;
    "")
        exit 0
        ;;
    *)
        TEMP="$SELECTED"
        ;;
esac

if ! [[ "$TEMP" =~ ^[0-9]+$ ]] || (( TEMP < 1000 || TEMP > 10000 )); then
    notify-send -u critical --expire-time=2000 "hyprsunset" "❌ Invalid temperature! Must be 1000 - 10000"
    exit 1
fi

if pgrep -x "hyprsunset" >/dev/null; then
    pkill -x "hyprsunset"
fi

hyprctl dispatch exec "hyprsunset -t $TEMP"
notify-send "🌡️ Temperature set to $TEMP K  "

exit 0
