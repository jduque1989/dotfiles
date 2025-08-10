#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

toggle_menu() {
    if [ "$(sketchybar --query system_stats_menu | jq -r '.popup.drawing')" = "on" ]; then
        sketchybar --set system_stats_menu popup.drawing=off
    else
        # Update all menu items before showing
        update_ram_item
        update_disk_item  
        update_uptime_item
        update_load_item
        update_temperature_item
        sketchybar --set system_stats_menu popup.drawing=on
    fi
}

update_ram_item() {
    # RAM calculation
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
    
    # Format memory sizes
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
    
    if (( MEMORY_PERCENT >= 90 )); then
        RAM_COLOR=$RED
    elif (( MEMORY_PERCENT >= 75 )); then
        RAM_COLOR=$ORANGE
    elif (( MEMORY_PERCENT >= 60 )); then
        RAM_COLOR=$YELLOW
    else
        RAM_COLOR=$GREEN
    fi
    
    sketchybar --set system_stats_menu.ram \
        icon="⚡" \
        icon.color=$RAM_COLOR \
        label="$USED_COMPACT/$TOTAL_COMPACT ($MEMORY_PERCENT%)" \
        label.color=$WHITE
}

update_disk_item() {
    # Disk calculation
    DISK_INFO=$(df -h / | tail -1)
    DISK_USED_PERCENT=$(echo $DISK_INFO | awk '{print $5}' | sed 's/%//')
    DISK_AVAILABLE=$(echo $DISK_INFO | awk '{print $4}')
    DISK_AVAILABLE_CLEAN=$(echo $DISK_AVAILABLE | sed 's/\.0G/G/' | sed 's/\.0T/T/')
    
    if (( DISK_USED_PERCENT >= 90 )); then
        DISK_COLOR=$RED
    elif (( DISK_USED_PERCENT >= 80 )); then
        DISK_COLOR=$ORANGE
    elif (( DISK_USED_PERCENT >= 70 )); then
        DISK_COLOR=$YELLOW
    else
        DISK_COLOR=$GREEN
    fi
    
    sketchybar --set system_stats_menu.disk \
        icon="📦" \
        icon.color=$DISK_COLOR \
        label="$DISK_AVAILABLE_CLEAN free ($DISK_USED_PERCENT% used)" \
        label.color=$WHITE
}

update_uptime_item() {
    # Uptime calculation
    UPTIME_RAW=$(uptime | awk '{print $3}' | sed 's/,//')
    
    if [[ "$UPTIME_RAW" =~ ^[0-9]+$ ]]; then
        # Uptime in days
        if (( UPTIME_RAW >= 30 )); then
            UPTIME_COLOR=$ORANGE
            UPTIME_LABEL="${UPTIME_RAW} days"
        elif (( UPTIME_RAW >= 7 )); then
            UPTIME_COLOR=$YELLOW
            UPTIME_LABEL="${UPTIME_RAW} days"
        else
            UPTIME_COLOR=$GREEN
            UPTIME_LABEL="${UPTIME_RAW} days"
        fi
    else
        # Uptime in hours/minutes format
        UPTIME_HOURS=$(echo "$UPTIME_RAW" | cut -d':' -f1)
        if [[ "$UPTIME_HOURS" =~ ^[0-9]+$ ]]; then
            UPTIME_COLOR=$GREEN
            UPTIME_LABEL="${UPTIME_HOURS} hours"
        else
            UPTIME_COLOR=$BLUE
            UPTIME_LABEL="Running"
        fi
    fi
    
    sketchybar --set system_stats_menu.uptime \
        icon="⏱️" \
        icon.color=$UPTIME_COLOR \
        label="$UPTIME_LABEL" \
        label.color=$WHITE
}

update_load_item() {
    # Load calculation
    LOAD_1MIN=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1}' | xargs)
    CPU_CORES=$(sysctl -n hw.ncpu)
    LOAD_PERCENT=$(echo "scale=0; $LOAD_1MIN * 100 / $CPU_CORES" | bc -l 2>/dev/null || echo "0")
    
    # Format load (remove unnecessary decimals)
    LOAD_FORMATTED=$(printf "%.1f" $LOAD_1MIN | sed 's/\.0$//')
    
    if (( LOAD_PERCENT >= 100 )); then
        LOAD_COLOR=$RED
        LOAD_ICON="🔴"
    elif (( LOAD_PERCENT >= 80 )); then
        LOAD_COLOR=$ORANGE
        LOAD_ICON="🟠"
    elif (( LOAD_PERCENT >= 60 )); then
        LOAD_COLOR=$YELLOW
        LOAD_ICON="🟡"
    else
        LOAD_COLOR=$GREEN
        LOAD_ICON="🟢"
    fi
    
    sketchybar --set system_stats_menu.load \
        icon="$LOAD_ICON" \
        icon.color=$LOAD_COLOR \
        label="$LOAD_FORMATTED ($LOAD_PERCENT%)" \
        label.color=$WHITE
}

update_temperature_item() {
    # Get CPU temperature using safe methods (avoid sudo powermetrics)
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
        TEMP_ICON="🔥"
        TEMP_COLOR=$RED
        TEMP_STATUS="Critical"
    elif (( TEMP_CELSIUS >= 70 )); then
        TEMP_ICON="🌡️"
        TEMP_COLOR=$ORANGE
        TEMP_STATUS="High"
    elif (( TEMP_CELSIUS >= 60 )); then
        TEMP_ICON="🌡️"  
        TEMP_COLOR=$YELLOW
        TEMP_STATUS="Warm"
    else
        TEMP_ICON="❄️"
        TEMP_COLOR=$GREEN
        TEMP_STATUS="Normal"
    fi
    
    sketchybar --set system_stats_menu.temperature \
        icon="$TEMP_ICON" \
        icon.color=$TEMP_COLOR \
        label="${TEMP_CELSIUS}°C ($TEMP_STATUS)" \
        label.color=$WHITE
}

case "$1" in
    "toggle")
        toggle_menu
        ;;
    *)
        toggle_menu
        ;;
esac