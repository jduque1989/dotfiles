#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get current date and time in a modern format
WEEKDAY=$(date '+%a')
DATE=$(date '+%d')
MONTH=$(date '+%b')
TIME=$(date '+%H:%M')

# Create a compact but informative display
# Format: "Mon 26 Nov 15:30"
LABEL="$WEEKDAY $DATE $MONTH $TIME"

sketchybar --set "$NAME" \
    label="$LABEL" \
    label.color=$WHITE \
    icon.color=$WHITE