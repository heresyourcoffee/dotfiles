#!/bin/bash

CHOICE=$(echo -e "  lock\n  sleep\n󰍃  exit\n  reboot\n  poweroff" | rofi -dmenu -p "Action: ")

case "$CHOICE" in
    "  lock")
	hyprlock
        ;;
    "  sleep")
	hyprlock &
	sleep 2
        systemctl suspend
        ;;
    "󰍃  exit")
	hyprctl dispatch exit
        ;;
    "  reboot")
        systemctl reboot
        ;;
    "  poweroff")
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
