# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                     🚀 Custom Prompt Module                                      ┃
# ┃                                For Warp & Other Terminals                                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Battery status function
get_battery_status() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local battery_info=$(pmset -g batt 2>/dev/null)
        if [[ -n "$battery_info" ]]; then
            local percentage=$(echo "$battery_info" | /usr/bin/grep -o '[0-9]\+%' | head -1)
            
            # Check for AC Power first, then battery status
            if echo "$battery_info" | /usr/bin/grep -q "AC Power"; then
                echo "🔌$percentage"
            elif echo "$battery_info" | /usr/bin/grep -q "charged"; then
                echo "🔋$percentage"
            elif echo "$battery_info" | /usr/bin/grep -q "charging"; then
                echo "🔌$percentage"
            elif echo "$battery_info" | /usr/bin/grep -q "discharging"; then
                local num=${percentage%\%}
                if [[ $num -le 20 ]]; then
                    echo "💀$percentage"
                elif [[ $num -le 50 ]]; then
                    echo "⚡$percentage"
                else
                    echo "🔋$percentage"
                fi
            else
                echo "❓$percentage"
            fi
        fi
    fi
}

# Memory usage function
get_memory_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local memory_pressure=$(memory_pressure 2>/dev/null | grep "System-wide memory free percentage" | awk '{print $5}' | tr -d '%')
        if [[ -n "$memory_pressure" ]]; then
            local used_percent=$((100 - memory_pressure))
            if [[ $used_percent -gt 80 ]]; then
                echo "🔥${used_percent}%"
            elif [[ $used_percent -gt 60 ]]; then
                echo "⚠️${used_percent}%"
            else
                echo "🐏${used_percent}%"
            fi
        else
            # Fallback method
            local mem_info=$(top -l 1 -s 0 | grep "PhysMem" | awk '{print $2,$4}' | tr -d 'M')
            if [[ -n "$mem_info" ]]; then
                local used=$(echo "$mem_info" | awk '{print $1}')
                local unused=$(echo "$mem_info" | awk '{print $2}')
                if [[ "$used" =~ ^[0-9]+$ && "$unused" =~ ^[0-9]+$ ]]; then
                    local total=$((used + unused))
                    local percent=$((used * 100 / total))
                    echo "🐏${percent}%"
                fi
            fi
        fi
    fi
}

# Shell indicator function
get_shell_info() {
    # Use $SHELL or $ZSH_NAME for more reliable detection
    if [[ -n "$ZSH_NAME" ]] || [[ "$SHELL" == *zsh* ]]; then
        echo "⚡zsh"
    elif [[ "$SHELL" == *bash* ]]; then
        echo "🐚bash"  
    elif [[ "$SHELL" == *fish* ]]; then
        echo "🐟fish"
    else
        echo "❓shell"
    fi
}

# Custom info bar function that prints system info
show_system_info() {
    local battery=$(get_battery_status)
    local memory=$(get_memory_usage)
    local shell=$(get_shell_info)
    local timestamp=$(date '+%H:%M:%S')
    
    echo ""
    echo "┌─────────────────────────────────────────────────────────────────────────────────────────┐"
    printf "│ %s | %s | %s | %s %*s │\n" \
        "$shell" \
        "${battery:-🔋N/A}" \
        "${memory:-🐏N/A}" \
        "🕒$timestamp" \
        $(( 75 - ${#shell} - ${#battery} - ${#memory} - 12 )) ""
    echo "└─────────────────────────────────────────────────────────────────────────────────────────┘"
}

# Warp integration: Add system info display
if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    # For Warp, we create a command to show system info (avoid alias conflicts)
    # Note: sysinfo and si are defined as functions in functions.zsh
    
    # Auto-show system info on directory changes
    chpwd() {
        show_system_info
    }
fi

# Right prompt for terminals that support it (not Warp)
if [[ "$TERM_PROGRAM" != "WarpTerminal" ]]; then
    # Custom right prompt
    RPS1='%F{8}$(get_battery_status) $(get_memory_usage) %*%f'
fi

# Functions are available in the current shell session