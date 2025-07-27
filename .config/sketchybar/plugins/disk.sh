#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get disk usage for root filesystem
DISK_INFO=$(df -h / | tail -1)
USED_PERCENT=$(echo $DISK_INFO | awk '{print $5}' | sed 's/%//')
AVAILABLE=$(echo $DISK_INFO | awk '{print $4}')

# Convert percentage to integer
USED_INT=${USED_PERCENT}

# Set icon and color based on disk usage
if (( USED_INT >= 90 )); then
    ICON="🚨"
    COLOR=$RED
elif (( USED_INT >= 80 )); then
    ICON="⚠️"
    COLOR=$ORANGE
elif (( USED_INT >= 70 )); then
    ICON="📦"
    COLOR=$YELLOW
else
    ICON="📦"
    COLOR=$GREEN
fi

# Ultra compact: show available space
# Format available space (remove decimal if GB)
AVAILABLE_CLEAN=$(echo $AVAILABLE | sed 's/\.0G/G/' | sed 's/\.0T/T/')

LABEL="$AVAILABLE_CLEAN"

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="$LABEL" \
    label.color=$WHITE