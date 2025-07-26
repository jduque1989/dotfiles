#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get total physical memory in bytes
TOTAL_MEMORY=$(sysctl -n hw.memsize)

# Get memory pressure info using memory_pressure command
MEMORY_PRESSURE=$(memory_pressure 2>/dev/null | head -1)

# Extract used memory from vm_stat for more accurate calculation
VM_STAT=$(vm_stat)
PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
PAGES_INACTIVE=$(echo "$VM_STAT" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
PAGES_SPECULATIVE=$(echo "$VM_STAT" | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
PAGES_COMPRESSED=$(echo "$VM_STAT" | grep "Pages occupied by compressor" | awk '{print $5}' | sed 's/\.//')

# Calculate used memory (4KB per page)
PAGE_SIZE=4096
USED_PAGES=$((PAGES_WIRED + PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_COMPRESSED))
USED_MEMORY=$((USED_PAGES * PAGE_SIZE))

# Calculate percentage
MEMORY_PERCENT=$((USED_MEMORY * 100 / TOTAL_MEMORY))

# Compact formatting - show only essential info
format_compact() {
    local bytes=$1
    if (( bytes > 1073741824 )); then
        local gb=$(( bytes / 1073741824 ))
        echo "${gb}G"
    else
        local mb=$(( bytes / 1048576 ))
        echo "${mb}M"
    fi
}

USED_COMPACT=$(format_compact $USED_MEMORY)
TOTAL_COMPACT=$(format_compact $TOTAL_MEMORY)

# Modern RAM icon based on usage
if (( MEMORY_PERCENT >= 90 )); then
    ICON="🧠"
    COLOR=$RED
elif (( MEMORY_PERCENT >= 75 )); then
    ICON="💾"
    COLOR=$ORANGE
elif (( MEMORY_PERCENT >= 60 )); then
    ICON="💿"
    COLOR=$YELLOW
else
    ICON="💿"
    COLOR=$GREEN
fi

# Compact display: "8G/16G"
LABEL="${USED_COMPACT}/${TOTAL_COMPACT}"

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="$LABEL" \
    label.color=$WHITE