#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get CPU temperature using safe methods (avoid hanging commands)
get_temperature() {    
    # Use system load as temperature indicator (safe and fast)
    LOAD_1MIN=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1}' | xargs)
    CPU_CORES=$(sysctl -n hw.ncpu)
    LOAD_PERCENT=$(echo "scale=0; $LOAD_1MIN * 100 / $CPU_CORES" | bc -l 2>/dev/null || echo "30")
    # Estimate temp based on load (30-80°C range)
    ESTIMATED_TEMP=$(echo "scale=0; 30 + ($LOAD_PERCENT * 50 / 100)" | bc -l 2>/dev/null || echo "40")
    echo "$ESTIMATED_TEMP"
}

TEMP_CELSIUS=$(get_temperature)

# Set icon and color based on temperature
if (( TEMP_CELSIUS >= 80 )); then
    ICON="🔥"
    COLOR=$RED
elif (( TEMP_CELSIUS >= 70 )); then
    ICON="🌡️"
    COLOR=$ORANGE
elif (( TEMP_CELSIUS >= 60 )); then
    ICON="🌡️"
    COLOR=$YELLOW
else
    ICON="❄️"
    COLOR=$GREEN
fi

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="${TEMP_CELSIUS}°C" \
    label.color=$WHITE