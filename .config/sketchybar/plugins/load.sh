#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get 1-minute load average
LOAD_1MIN=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1}' | xargs)

# Get number of CPU cores for context
CPU_CORES=$(sysctl -n hw.ncpu)

# Convert load to percentage of CPU capacity
LOAD_PERCENT=$(echo "scale=0; $LOAD_1MIN * 100 / $CPU_CORES" | bc -l 2>/dev/null || echo "0")

# Set icon and color based on load percentage
if (( LOAD_PERCENT >= 100 )); then
    ICON="🔴"
    COLOR=$RED
elif (( LOAD_PERCENT >= 80 )); then
    ICON="🟠"
    COLOR=$ORANGE
elif (( LOAD_PERCENT >= 60 )); then
    ICON="🟡"
    COLOR=$YELLOW
else
    ICON="🟢"
    COLOR=$GREEN
fi

# Compact display: show load with context
# Format load (remove unnecessary decimals)
LOAD_FORMATTED=$(printf "%.1f" $LOAD_1MIN | sed 's/\.0$//')

LABEL="$LOAD_FORMATTED"

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="$LABEL" \
    label.color=$WHITE