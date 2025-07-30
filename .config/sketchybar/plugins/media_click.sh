#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get current media source
CURRENT_SOURCE=$(cat /tmp/sketchybar_media_source 2>/dev/null || echo "")

toggle_menu() {
    if [ "$(sketchybar --query media_player | jq -r '.popup.drawing')" = "on" ]; then
        sketchybar --set media_player popup.drawing=off
    else
        update_menu_items
        sketchybar --set media_player popup.drawing=on
    fi
}

update_menu_items() {
    case "$CURRENT_SOURCE" in
        "spotify_player")
            # spotify_player controls
            SPOTIFY_PLAYER_PATH="/Users/juandavidduquea/.cargo/bin/spotify_player"
            PLAYBACK_JSON=$($SPOTIFY_PLAYER_PATH get key playback 2>/dev/null)
            IS_PLAYING=$(echo "$PLAYBACK_JSON" | jq -r '.is_playing // false' 2>/dev/null)
            if [[ "$IS_PLAYING" == "true" ]]; then
                PLAY_PAUSE_ICON="⏸️"
                PLAY_PAUSE_LABEL="Pause"
            else
                PLAY_PAUSE_ICON="▶️"
                PLAY_PAUSE_LABEL="Play"
            fi
            
            sketchybar --set media_player.previous \
                icon="⏮️" \
                icon.color=$WHITE \
                label="Previous" \
                label.color=$WHITE \
                drawing=on
                
            sketchybar --set media_player.playpause \
                icon="$PLAY_PAUSE_ICON" \
                icon.color=$WHITE \
                label="$PLAY_PAUSE_LABEL" \
                label.color=$WHITE \
                drawing=on
                
            sketchybar --set media_player.next \
                icon="⏭️" \
                icon.color=$WHITE \
                label="Next" \
                label.color=$WHITE \
                drawing=on
            ;;
        "spotify")
            # Spotify controls
            PLAYER_STATE=$(osascript -e 'tell application "Spotify" to get player state as string' 2>/dev/null)
            if [[ "$PLAYER_STATE" == "playing" ]]; then
                PLAY_PAUSE_ICON="⏸️"
                PLAY_PAUSE_LABEL="Pause"
            else
                PLAY_PAUSE_ICON="▶️"
                PLAY_PAUSE_LABEL="Play"
            fi
            
            sketchybar --set media_player.previous \
                icon="⏮️" \
                icon.color=$WHITE \
                label="Previous" \
                label.color=$WHITE \
                drawing=on
                
            sketchybar --set media_player.playpause \
                icon="$PLAY_PAUSE_ICON" \
                icon.color=$WHITE \
                label="$PLAY_PAUSE_LABEL" \
                label.color=$WHITE \
                drawing=on
                
            sketchybar --set media_player.next \
                icon="⏭️" \
                icon.color=$WHITE \
                label="Next" \
                label.color=$WHITE \
                drawing=on
            ;;
        "youtube")
            # YouTube controls (basic play/pause via spacebar)
            sketchybar --set media_player.previous \
                icon="🔄" \
                icon.color=$WHITE \
                label="Reload" \
                label.color=$WHITE \
                drawing=on
                
            sketchybar --set media_player.playpause \
                icon="⏯️" \
                icon.color=$WHITE \
                label="Play/Pause" \
                label.color=$WHITE \
                drawing=on
                
            sketchybar --set media_player.next \
                icon="🔗" \
                icon.color=$WHITE \
                label="Open Tab" \
                label.color=$WHITE \
                drawing=on
            ;;
        *)
            # No active media - hide menu items
            sketchybar --set media_player.previous drawing=off
            sketchybar --set media_player.playpause drawing=off  
            sketchybar --set media_player.next drawing=off
            ;;
    esac
}

case "$1" in
    "previous")
        case "$CURRENT_SOURCE" in
            "spotify_player")
                /Users/juandavidduquea/.cargo/bin/spotify_player playback previous 2>/dev/null
                ;;
            "spotify")
                osascript -e 'tell application "Spotify" to previous track'
                ;;
            "youtube")
                # Reload the page (go back to start)
                if pgrep -x "Google Chrome" > /dev/null; then
                    osascript -e 'tell application "Google Chrome" to reload active tab of first window'
                elif pgrep -x "Safari" > /dev/null; then
                    osascript -e 'tell application "Safari" to do JavaScript "location.reload()" in current tab of first window'
                fi
                ;;
        esac
        sketchybar --trigger media_update
        ;;
    "playpause")
        case "$CURRENT_SOURCE" in
            "spotify_player")
                /Users/juandavidduquea/.cargo/bin/spotify_player playback play-pause 2>/dev/null
                ;;
            "spotify")
                osascript -e 'tell application "Spotify" to playpause'
                ;;
            "youtube")
                # Send spacebar to active browser for play/pause
                if pgrep -x "Google Chrome" > /dev/null; then
                    osascript -e 'tell application "Google Chrome" to activate' -e 'tell application "System Events" to key code 49'
                elif pgrep -x "Safari" > /dev/null; then
                    osascript -e 'tell application "Safari" to activate' -e 'tell application "System Events" to key code 49'
                fi
                ;;
        esac
        sketchybar --trigger media_update
        ;;
    "next")
        case "$CURRENT_SOURCE" in
            "spotify_player")
                /Users/juandavidduquea/.cargo/bin/spotify_player playback next 2>/dev/null
                ;;
            "spotify")
                osascript -e 'tell application "Spotify" to next track'
                ;;
            "youtube")
                # Bring browser to front
                if pgrep -x "Google Chrome" > /dev/null; then
                    osascript -e 'tell application "Google Chrome" to activate'
                elif pgrep -x "Safari" > /dev/null; then
                    osascript -e 'tell application "Safari" to activate'
                fi
                ;;
        esac
        sketchybar --trigger media_update
        ;;
    *)
        toggle_menu
        ;;
esac