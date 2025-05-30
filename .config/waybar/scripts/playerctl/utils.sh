#!/bin/bash

escape_markup() {
    echo "$1" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g;'
}

truncate_string() {
    local input="$1"
    if [ "${#input}" -gt 25 ]; then
        echo "${input:0:22}..."
    else
        echo "$input"
    fi
}
