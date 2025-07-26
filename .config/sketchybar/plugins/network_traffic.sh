#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get primary network interface
INTERFACE=$(route get default | grep interface | awk '{print $2}' | head -1)

# File to store previous values
TEMP_FILE="/tmp/sketchybar_network_traffic"

# Get current network stats
CURRENT_STATS=$(netstat -I $INTERFACE -b | tail -1)
RX_BYTES=$(echo $CURRENT_STATS | awk '{print $7}')
TX_BYTES=$(echo $CURRENT_STATS | awk '{print $10}')

# Compact speed formatting
format_speed_compact() {
    local bytes_per_sec=$1
    if (( bytes_per_sec > 1048576 )); then
        local mb=$(( bytes_per_sec / 1048576 ))
        echo "${mb}M"
    elif (( bytes_per_sec > 1024 )); then
        local kb=$(( bytes_per_sec / 1024 ))
        echo "${kb}K"
    else
        echo "${bytes_per_sec}B"
    fi
}

# Read previous values if they exist
if [[ -f "$TEMP_FILE" ]]; then
    PREV_DATA=$(cat "$TEMP_FILE")
    PREV_TIME=$(echo $PREV_DATA | awk '{print $1}')
    PREV_RX=$(echo $PREV_DATA | awk '{print $2}')
    PREV_TX=$(echo $PREV_DATA | awk '{print $3}')
    
    CURRENT_TIME=$(date +%s)
    TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
    
    if [[ $TIME_DIFF -gt 0 ]]; then
        RX_SPEED=$(( (RX_BYTES - PREV_RX) / TIME_DIFF ))
        TX_SPEED=$(( (TX_BYTES - PREV_TX) / TIME_DIFF ))
        
        # Format speeds compactly
        RX_FORMATTED=$(format_speed_compact $RX_SPEED)
        TX_FORMATTED=$(format_speed_compact $TX_SPEED)
        
        # Set icon and color based on activity level
        TOTAL_SPEED=$((RX_SPEED + TX_SPEED))
        if (( TOTAL_SPEED > 1048576 )); then
            ICON="🚀"
            COLOR=$GREEN
        elif (( TOTAL_SPEED > 10240 )); then
            ICON="📡"
            COLOR=$YELLOW
        else
            ICON="📡"
            COLOR=$GREY
        fi
        
        # Ultra compact: "↓1M↑500K"
        LABEL="↓${RX_FORMATTED}↑${TX_FORMATTED}"
    else
        ICON="📡"
        COLOR=$GREY
        LABEL="↓0↑0"
    fi
else
    ICON="📡"
    COLOR=$GREY
    LABEL="↓0↑0"
fi

# Store current values for next run
echo "$(date +%s) $RX_BYTES $TX_BYTES" > "$TEMP_FILE"

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="$LABEL" \
    label.color=$WHITE