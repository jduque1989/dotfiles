#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get WiFi interface name (usually en0 on modern Macs)
WIFI_INTERFACE=$(networksetup -listallhardwareports | grep -A 1 "Wi-Fi" | grep "Device:" | awk '{print $2}')

# Get WiFi SSID using modern approach
WIFI_SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID:" | awk -F': ' '{print $2}' | tr -d ' ')

# Get current local IP address
LOCAL_IP=$(ifconfig $WIFI_INTERFACE 2>/dev/null | grep "inet " | awk '{print $2}' | head -1)

# Get public IP address (with timeout to avoid hanging)
PUBLIC_IP=$(curl -s --max-time 3 --connect-timeout 2 ifconfig.me 2>/dev/null || curl -s --max-time 3 --connect-timeout 2 ipinfo.io/ip 2>/dev/null || echo "")

# Check if WiFi is connected
WIFI_STATUS=$(ifconfig $WIFI_INTERFACE 2>/dev/null | grep "status: active")

# Check internet connectivity quickly
INTERNET_STATUS=$(ping -c 1 -W 1000 1.1.1.1 >/dev/null 2>&1 && echo "connected" || echo "disconnected")

# Set display with router icon and public IP
if [[ -n "$WIFI_STATUS" && "$INTERNET_STATUS" == "connected" ]]; then
    # Connected with internet - show public IP address
    ICON="🛜"
    if [[ -n "$PUBLIC_IP" ]]; then
        LABEL="$PUBLIC_IP"
    elif [[ -n "$LOCAL_IP" ]]; then
        # Fallback to local IP if public IP fetch fails
        LABEL="$LOCAL_IP"
    else
        LABEL="Connected"
    fi
    COLOR=$GREEN
elif [[ -n "$WIFI_STATUS" ]]; then
    # Connected but no internet
    ICON="🛜"
    LABEL="No Net"
    COLOR=$ORANGE
else
    # No WiFi
    ICON="🛜"
    LABEL="Off"
    COLOR=$RED
fi

sketchybar --set $NAME \
    icon="$ICON" \
    icon.color=$COLOR \
    label="$LABEL" \
    label.color=$WHITE