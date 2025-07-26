#!/bin/bash

# Modern Aerospace workspace plugin
source "$HOME/.config/sketchybar/colors.sh"

# Get workspace name
WORKSPACE=${NAME#space_}

# Get current focused workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null || echo "")

# Get window count
APP_COUNT=$(aerospace list-windows --workspace $WORKSPACE 2>/dev/null | wc -l | tr -d ' ')

# Get primary app
PRIMARY_APP=""
if [ "$APP_COUNT" -gt 0 ]; then
    PRIMARY_APP=$(aerospace list-windows --workspace $WORKSPACE --format '%{app-name}' 2>/dev/null | head -1)
fi

# Create indicator
if [ "$APP_COUNT" -gt 0 ]; then
    if [ "$APP_COUNT" -eq 1 ]; then
        INDICATOR="•"
    elif [ "$APP_COUNT" -eq 2 ]; then
        INDICATOR="••"
    elif [ "$APP_COUNT" -eq 3 ]; then
        INDICATOR="•••"
    else
        INDICATOR="•••+"
    fi
else
    INDICATOR=""
fi

# Set label text
if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ] && [ -n "$PRIMARY_APP" ]; then
    LABEL_TEXT=" $PRIMARY_APP"
elif [ -n "$INDICATOR" ]; then
    LABEL_TEXT=" $INDICATOR"
else
    LABEL_TEXT=""
fi

# Update appearance
if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
    # Active workspace
    sketchybar --set $NAME \
        background.color=$WORKSPACE_ACTIVE_BG \
        icon.color=$WORKSPACE_ACTIVE_TEXT \
        label.color=$WORKSPACE_ACTIVE_TEXT \
        label="$LABEL_TEXT" \
        label.drawing=on
elif [ "$APP_COUNT" -gt 0 ]; then
    # Occupied workspace
    sketchybar --set $NAME \
        background.color=$WORKSPACE_OCCUPIED_BG \
        icon.color=$WORKSPACE_OCCUPIED_TEXT \
        label.color=$WORKSPACE_OCCUPIED_TEXT \
        label="$LABEL_TEXT" \
        label.drawing=on
else
    # Empty workspace
    sketchybar --set $NAME \
        background.color=$WORKSPACE_EMPTY_BG \
        icon.color=$WORKSPACE_EMPTY_TEXT \
        label.color=$WORKSPACE_EMPTY_TEXT \
        label="" \
        label.drawing=off
fi