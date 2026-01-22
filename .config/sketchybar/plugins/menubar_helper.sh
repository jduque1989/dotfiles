#!/bin/bash

# Menubar Helper for macOS Tahoe Liquid Glass
# Monitors mouse position and hides/shows sketchybar with animations
# to avoid overlap with the macOS menu bar

# Source colors from sketchybar config
source "$HOME/.config/sketchybar/colors.sh"

# Full path for LaunchAgent compatibility
SKETCHYBAR="/opt/homebrew/bin/sketchybar"

HIDE_ZONE=5          # Pixels from top to trigger hide
SHOW_ZONE=50         # Pixels from top to show again
ANIMATION_DURATION=4 # Animation frames (lower = faster)
STATE_FILE="/tmp/sketchybar_hidden"

# Get current mouse position from top of screen
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
get_mouse_from_top() {
    "$PLUGIN_DIR/mouse_position" 2>/dev/null || echo "999"
}

# Hide sketchybar by sliding up (out of the way)
hide_bar() {
    if [ ! -f "$STATE_FILE" ]; then
        touch "$STATE_FILE"
        # Smooth animation: slide up to hide
        $SKETCHYBAR --animate tanh $ANIMATION_DURATION --bar y_offset=-45
    fi
}

# Show sketchybar by sliding back down to original position
show_bar() {
    if [ -f "$STATE_FILE" ]; then
        rm -f "$STATE_FILE"
        # Smooth animation: slide back down to visible
        $SKETCHYBAR --animate tanh $ANIMATION_DURATION --bar y_offset=0
    fi
}

# Toggle function for manual control (keyboard shortcut)
toggle_bar() {
    if [ -f "$STATE_FILE" ]; then
        show_bar
    else
        hide_bar
    fi
}

# Force reset to visible state
reset_bar() {
    rm -f "$STATE_FILE"
    $SKETCHYBAR --bar y_offset=0
}

# Main monitoring loop with debouncing
monitor() {
    local last_state="visible"
    local hide_counter=0
    local show_counter=0
    local DEBOUNCE_HIDE=2 # Number of consecutive checks before hiding
    local DEBOUNCE_SHOW=3 # Number of consecutive checks before showing

    # Reset state on start
    rm -f "$STATE_FILE"

    while true; do
        MOUSE_FROM_TOP=$(get_mouse_from_top)

        if [ "$MOUSE_FROM_TOP" -le "$HIDE_ZONE" ]; then
            ((hide_counter++))
            show_counter=0
            if [ "$hide_counter" -ge "$DEBOUNCE_HIDE" ] && [ "$last_state" = "visible" ]; then
                hide_bar
                last_state="hidden"
            fi
        elif [ "$MOUSE_FROM_TOP" -gt "$SHOW_ZONE" ]; then
            ((show_counter++))
            hide_counter=0
            if [ "$show_counter" -ge "$DEBOUNCE_SHOW" ] && [ "$last_state" = "hidden" ]; then
                show_bar
                last_state="visible"
            fi
        else
            # In transition zone - reset counters
            hide_counter=0
            show_counter=0
        fi

        sleep 0.1
    done
}

case "$1" in
hide)
    hide_bar
    ;;
show)
    show_bar
    ;;
toggle)
    toggle_bar
    ;;
reset)
    reset_bar
    ;;
monitor)
    monitor
    ;;
*)
    echo "Usage: $0 {hide|show|toggle|reset|monitor}"
    echo ""
    echo "Commands:"
    echo "  monitor - Start background monitoring (run as daemon)"
    echo "  hide    - Manually hide sketchybar"
    echo "  show    - Manually show sketchybar"
    echo "  toggle  - Toggle visibility"
    echo "  reset   - Force reset to visible state"
    exit 1
    ;;
esac
