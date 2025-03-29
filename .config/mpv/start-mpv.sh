#!/bin/sh

SONG_DIR="$HOME/Music"
OPTIONS="#Random\n#Open in zen browser\n#Playlist: Heaven's feel\n#Playlist: MrSuicideSheep"
SONG=$(echo -e "$OPTIONS\n$(ls "$SONG_DIR/download")\n$(ls "$SONG_DIR/songs")\n#Import from clipboard" | rofi -config ~/.config/rofi/mpv.rasi -dmenu -replace -p "󰎇")
if [ -n "$SONG" ]; then
	case "$SONG" in
        "#Random")
            SONG=$SONG_DIR
            ;;
        "#Import from clipboard")
	    if [[ "$(wl-paste)" =~ ^https?://* ]]; then
		SONG=$(wl-paste)
	    else
		notify-send "Invalid link"
		exit 1
	    fi
	    ;;
	"#Open in zen browser")
	    if [ -z "$(playerctl metadata xesam:url)" ]; then
		notify-send "URL not found"
		exit 1
	    else
	        playerctl pause
	        zen-browser --new-tab "$(playerctl metadata xesam:url)"
	    fi
	    exit 0
	    ;;
	"#Playlist: Heaven's feel")
	    SONG="https://music.youtube.com/playlist?list=PLSZoBjX9cgO4bS5GCalACRHVnKvcK9LwQ&si=hu0hFsyDxLVaW-1j"
	    ;;
	"#Playlist: MrSuicideSheep")
	    SONG="https://music.youtube.com/playlist?list=PLDfKAXSi6kUZnATwAUfN6tg1dULU-7XcD&si=7telm382oVSW_kg2"
	    ;;
        *)
            if [ -f "$SONG_DIR/download/$SONG" ]; then
                SONG="$SONG_DIR/download/$SONG"
            elif [ -f "$SONG_DIR/songs/$SONG" ]; then
                SONG="$SONG_DIR/songs/$SONG"
            else
                notify-send "File not found"
                exit 1
            fi
            ;;
    esac
    echo "Chosen song : $SONG"
    playerctl stop || echo "no players to stop"
    mpv --no-video --shuffle "$SONG" || notify-send "Error playing this song"
else
    echo "No song selected :( "
fi
