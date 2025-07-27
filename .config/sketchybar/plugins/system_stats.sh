#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get RAM info
TOTAL_MEMORY=$(sysctl -n hw.memsize)
VM_STAT=$(vm_stat)
PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
PAGES_INACTIVE=$(echo "$VM_STAT" | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
PAGES_SPECULATIVE=$(echo "$VM_STAT" | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
PAGES_COMPRESSED=$(echo "$VM_STAT" | grep "Pages occupied by compressor" | awk '{print $5}' | sed 's/\.//')
PAGE_SIZE=4096
USED_PAGES=$((PAGES_WIRED + PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_COMPRESSED))
USED_MEMORY=$((USED_PAGES * PAGE_SIZE))
MEMORY_PERCENT=$((USED_MEMORY * 100 / TOTAL_MEMORY))

# Get disk info
DISK_INFO=$(df -h / | tail -1)
DISK_USED_PERCENT=$(echo $DISK_INFO | awk '{print $5}' | sed 's/%//')

# Get load average
LOAD_1MIN=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1}' | xargs)
CPU_CORES=$(sysctl -n hw.ncpu)
LOAD_PERCENT=$(echo "scale=0; $LOAD_1MIN * 100 / $CPU_CORES" | bc -l 2>/dev/null || echo "0")

# Determine the most critical status
if (( MEMORY_PERCENT >= 90 || DISK_USED_PERCENT >= 90 || LOAD_PERCENT >= 100 )); then
    COLOR=$RED
    ICON="🔴"
elif (( MEMORY_PERCENT >= 75 || DISK_USED_PERCENT >= 80 || LOAD_PERCENT >= 80 )); then
    COLOR=$ORANGE  
    ICON="🟠"
elif (( MEMORY_PERCENT >= 60 || DISK_USED_PERCENT >= 70 || LOAD_PERCENT >= 60 )); then
    COLOR=$YELLOW
    ICON="🟡"
else
    COLOR=$GREEN
    ICON="🟢"
fi

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="SYS" \
    label.color=$WHITE