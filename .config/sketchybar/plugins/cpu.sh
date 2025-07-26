#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get CPU usage using iostat (more reliable than top)
CPU_USAGE=$(iostat -c 2 | tail -1 | awk '{print 100-$6}' | cut -d. -f1)

# Fallback to ps if iostat doesn't work
if [[ -z "$CPU_USAGE" || "$CPU_USAGE" == "100" ]]; then
    CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')
fi

# Ensure we have a valid number
if [[ ! "$CPU_USAGE" =~ ^[0-9]+$ ]]; then
    CPU_USAGE=0
fi

# Modern compact icons and colors
if (( CPU_USAGE >= 80 )); then
    ICON="🔥"
    COLOR=$RED
elif (( CPU_USAGE >= 60 )); then
    ICON="⚡"
    COLOR=$ORANGE
elif (( CPU_USAGE >= 40 )); then
    ICON="💻"
    COLOR=$YELLOW
else
    ICON="💻"
    COLOR=$GREEN
fi

# Compact display: just percentage
LABEL="${CPU_USAGE}%"

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="$LABEL" \
    label.color=$WHITE