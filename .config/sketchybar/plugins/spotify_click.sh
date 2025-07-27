#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

toggle_menu() {
    if [ "$(sketchybar --query spotify | jq -r '.popup.drawing')" = "on" ]; then
        sketchybar --set spotify popup.drawing=off
    else
        update_menu_items
        sketchybar --set spotify popup.drawing=on
    fi
}

update_menu_items() {
    # Get current playback state
    PLAYER_STATE=$(osascript -e 'tell application "Spotify" to get player state as string' 2>/dev/null)
    
    if [[ "$PLAYER_STATE" == "playing" ]]; then
        PLAY_PAUSE_ICON="⏸️"
        PLAY_PAUSE_LABEL="Pause"
    else
        PLAY_PAUSE_ICON="▶️"
        PLAY_PAUSE_LABEL="Play"
    fi
    
    sketchybar --set spotify.previous \
        icon="⏮️" \
        icon.color=$WHITE \
        label="Previous" \
        label.color=$WHITE
        
    sketchybar --set spotify.playpause \
        icon="$PLAY_PAUSE_ICON" \
        icon.color=$WHITE \
        label="$PLAY_PAUSE_LABEL" \
        label.color=$WHITE
        
    sketchybar --set spotify.next \
        icon="⏭️" \
        icon.color=$WHITE \
        label="Next" \
        label.color=$WHITE
}

case "$1" in
    "previous")
        osascript -e 'tell application "Spotify" to previous track'
        sketchybar --trigger spotify_update
        ;;
    "playpause")
        osascript -e 'tell application "Spotify" to playpause'
        sketchybar --trigger spotify_update
        ;;
    "next")
        osascript -e 'tell application "Spotify" to next track'
        sketchybar --trigger spotify_update
        ;;
    *)
        toggle_menu
        ;;
esac