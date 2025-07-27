#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Function to get Spotify info
get_spotify_info() {
    if pgrep -x "Spotify" > /dev/null; then
        osascript <<EOF 2>/dev/null
        tell application "Spotify"
            if player state is playing then
                set track_name to name of current track
                set artist_name to artist of current track
                return "spotify|♪|" & track_name & " • " & artist_name
            else
                return ""
            end if
        end tell
EOF
    fi
}

# Function to get YouTube info from Chrome
get_chrome_youtube() {
    if pgrep -x "Google Chrome" > /dev/null; then
        osascript <<EOF 2>/dev/null
        tell application "Google Chrome"
            if (count of windows) > 0 then
                set tab_title to title of active tab of first window
                set tab_url to URL of active tab of first window
                if tab_url contains "youtube.com/watch" then
                    -- Remove " - YouTube" suffix if present
                    set youtube_title to tab_title
                    if youtube_title ends with " - YouTube" then
                        set youtube_title to text 1 thru -11 of youtube_title
                    end if
                    return "youtube|📺|" & youtube_title
                end if
            end if
            return ""
        end tell
EOF
    fi
}

# Function to get YouTube info from Safari
get_safari_youtube() {
    if pgrep -x "Safari" > /dev/null; then
        osascript <<EOF 2>/dev/null
        tell application "Safari"
            if (count of windows) > 0 then
                set tab_title to name of current tab of first window
                set tab_url to URL of current tab of first window
                if tab_url contains "youtube.com/watch" then
                    -- Remove " - YouTube" suffix if present
                    set youtube_title to tab_title
                    if youtube_title ends with " - YouTube" then
                        set youtube_title to text 1 thru -11 of youtube_title
                    end if
                    return "youtube|📺|" & youtube_title
                end if
            end if
            return ""
        end tell
EOF
    fi
}

# Try to get media info from different sources (priority order)
MEDIA_INFO=""

# Check Spotify first (highest priority for music)
SPOTIFY_INFO=$(get_spotify_info)
if [[ -n "$SPOTIFY_INFO" && "$SPOTIFY_INFO" != "" ]]; then
    MEDIA_INFO="$SPOTIFY_INFO"
fi

# Check YouTube in Chrome if no Spotify
if [[ -z "$MEDIA_INFO" ]]; then
    CHROME_YOUTUBE=$(get_chrome_youtube)
    if [[ -n "$CHROME_YOUTUBE" && "$CHROME_YOUTUBE" != "" ]]; then
        MEDIA_INFO="$CHROME_YOUTUBE"
    fi
fi

# Check YouTube in Safari if no other media
if [[ -z "$MEDIA_INFO" ]]; then
    SAFARI_YOUTUBE=$(get_safari_youtube)
    if [[ -n "$SAFARI_YOUTUBE" && "$SAFARI_YOUTUBE" != "" ]]; then
        MEDIA_INFO="$SAFARI_YOUTUBE"
    fi
fi

# Parse and display media info
if [[ -n "$MEDIA_INFO" && "$MEDIA_INFO" != "" ]]; then
    # Split the info: source|icon|title
    IFS='|' read -r SOURCE ICON TITLE <<< "$MEDIA_INFO"
    
    # Truncate if too long (keep it minimalist)
    if [[ ${#TITLE} -gt 45 ]]; then
        TITLE="${TITLE:0:42}..."
    fi
    
    # Store the current source for click handling
    echo "$SOURCE" > /tmp/sketchybar_media_source
    
    sketchybar --set $NAME \
        icon="$ICON" \
        icon.color=$GREEN \
        label="$TITLE" \
        label.color=$WHITE \
        drawing=on
else
    # Hide when nothing is playing
    echo "" > /tmp/sketchybar_media_source
    sketchybar --set $NAME \
        icon="" \
        label="" \
        drawing=off
fi