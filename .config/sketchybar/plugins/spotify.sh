#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Check if Spotify is running
if ! pgrep -x "Spotify" > /dev/null; then
    sketchybar --set $NAME \
        icon="" \
        label="" \
        drawing=off
    exit 0
fi

# Get current track info using AppleScript
get_spotify_info() {
    osascript <<EOF
    tell application "Spotify"
        if player state is playing then
            set track_name to name of current track
            set artist_name to artist of current track
            return track_name & " • " & artist_name
        else
            return ""
        end if
    end tell
EOF
}

TRACK_INFO=$(get_spotify_info 2>/dev/null)

if [[ -n "$TRACK_INFO" && "$TRACK_INFO" != "" ]]; then
    # Truncate if too long (keep it minimalist)
    if [[ ${#TRACK_INFO} -gt 40 ]]; then
        TRACK_INFO="${TRACK_INFO:0:37}..."
    fi
    
    sketchybar --set $NAME \
        icon="♪" \
        icon.color=$GREEN \
        label="$TRACK_INFO" \
        label.color=$WHITE \
        drawing=on
else
    # Hide when not playing
    sketchybar --set $NAME \
        icon="" \
        label="" \
        drawing=off
fi