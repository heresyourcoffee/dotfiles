#!/bin/sh
if pgrep -x "waybar" > /dev/null; then
    killall playerctl
    killall -SIGUSR2 waybar
else
    killall playerctl
    waybar &
fi
