#!/usr/bin/env bash

# Colors - LTMNight Palette
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}╔══════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║      ${RED}HyprLTM-Net Uninstaller${PURPLE}             ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════╝${NC}"
echo ""

# Define paths
SCRIPT_PATH="$HOME/.local/bin/hyprltm-net"
DESKTOP_ENTRY="$HOME/.local/share/applications/hyprltm-net.desktop"
ICON_PATH="$HOME/.local/share/icons/hicolor/scalable/apps/hyprltm-net.svg"
THEME_PATH_1="$HOME/.config/rofi/themes/hyprltm-net.rasi"
THEME_PATH_2="$HOME/.config/rofi/themes/ltmnight.rasi"

# Confirmation
echo -e "${YELLOW}This will remove HyprLTM-Net and its associated files.${NC}"
read -p "Are you sure you want to uninstall? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}Uninstallation cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${CYAN}Removing files...${NC}"

# Remove script
if [ -f "$SCRIPT_PATH" ]; then
    rm "$SCRIPT_PATH"
    echo -e "  ${GREEN}✓${NC} Removed $SCRIPT_PATH"
else
    echo -e "  ${YELLOW}!${NC} Script not found at $SCRIPT_PATH (already removed?)"
fi

# Remove Desktop Entry
if [ -f "$DESKTOP_ENTRY" ]; then
    rm "$DESKTOP_ENTRY"
    echo -e "  ${GREEN}✓${NC} Removed $DESKTOP_ENTRY"
else
    echo -e "  ${YELLOW}!${NC} Desktop Entry not found (skipping)"
fi

# Remove Icon
if [ -f "$ICON_PATH" ]; then
    rm "$ICON_PATH"
    echo -e "  ${GREEN}✓${NC} Removed $ICON_PATH"
else
    echo -e "  ${YELLOW}!${NC} Icon not found (skipping)"
fi

# Remove Themes
if [ -f "$THEME_PATH_1" ]; then
    rm "$THEME_PATH_1"
    echo -e "  ${GREEN}✓${NC} Removed $THEME_PATH_1"
else
    echo -e "  ${YELLOW}!${NC} Theme hyprltm-net.rasi not found (skipping)"
fi

if [ -f "$THEME_PATH_2" ]; then
    rm "$THEME_PATH_2"
    echo -e "  ${GREEN}✓${NC} Removed $THEME_PATH_2"
else
    echo -e "  ${YELLOW}!${NC} Theme ltmnight.rasi not found (skipping)"
fi

# Reminder for manual cleanup
echo ""
echo -e "${PURPLE}╔══════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║      ${GREEN}Uninstallation Complete!${PURPLE}            ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Manual Cleanup Reminders:${NC}"
echo -e "  1. Remove keybind from ${CYAN}~/.config/hypr/hyprland.conf${NC}:"
echo -e "     ${RED}bind = SUPER, N, exec, hyprltm-net${NC}"
echo ""
echo -e "  2. Remove on-click from ${CYAN}~/.config/waybar/config.jsonc${NC}:"
echo -e "     ${RED}\"on-click\": \"hyprltm-net\"${NC}"
echo ""
echo -e "${CYAN}Thank you for using HyprLTM-Net!${NC}"
