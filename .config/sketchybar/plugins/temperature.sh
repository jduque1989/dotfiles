#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get system uptime instead of unreliable temperature
UPTIME_RAW=$(uptime | awk '{print $3}' | sed 's/,//')

# Convert uptime to more readable format
if [[ "$UPTIME_RAW" =~ ^[0-9]+$ ]]; then
    # Uptime in days
    if (( UPTIME_RAW >= 30 )); then
        ICON="📅"
        LABEL="${UPTIME_RAW}d"
        COLOR=$ORANGE  # Long uptime might need restart
    elif (( UPTIME_RAW >= 7 )); then
        ICON="⏱️"
        LABEL="${UPTIME_RAW}d"
        COLOR=$YELLOW
    else
        ICON="⏱️"
        LABEL="${UPTIME_RAW}d"
        COLOR=$GREEN
    fi
else
    # Uptime in hours/minutes format - extract hours
    UPTIME_HOURS=$(echo "$UPTIME_RAW" | cut -d':' -f1)
    if [[ "$UPTIME_HOURS" =~ ^[0-9]+$ ]]; then
        ICON="⏱️"
        LABEL="${UPTIME_HOURS}h"
        COLOR=$GREEN
    else
        # Fallback to simple uptime display
        ICON="⏱️"
        LABEL="Up"
        COLOR=$BLUE
    fi
fi

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="$LABEL" \
    label.color=$WHITE