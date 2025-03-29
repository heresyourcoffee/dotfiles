#!/bin/bash

. "${HOME}/.cache/wal/colors.sh"

conffile="$HOME/.config/mako/config"

declare -A colors
colors=(
    ["background-color"]="${background}89"
    ["text-color"]="$foreground"
    ["border-color"]="$color13"
)

for color_name in "${!colors[@]}"; do
  sed -i "0,/^$color_name.*/{s//$color_name=${colors[$color_name]}/}" "$conffile"
done

makoctl reload
