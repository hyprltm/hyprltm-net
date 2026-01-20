#!/usr/bin/env bash

# Colors - LTMNight Palette
GREEN='\033[0;32m'   # 50fa7b
RED='\033[0;31m'     # ff5555
YELLOW='\033[1;33m'  # f1fa8c
PURPLE='\033[0;35m'  # bd93f9
CYAN='\033[0;36m'    # 8be9fd
NC='\033[0m'         # No Color

echo -e "${PURPLE}╔══════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║      ${CYAN}HyprLTM-Net Installer${PURPLE}               ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════╝${NC}"
echo ""

# Distro Detection
DISTRO="unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        arch|manjaro|endeavouros|garuda) DISTRO="arch" ;;
        fedora) DISTRO="fedora" ;;
        opensuse-tumbleweed|opensuse-leap) DISTRO="suse" ;;
        nixos) DISTRO="nixos" ;;
        *) DISTRO="unknown" ;;
    esac
fi
echo -e "${CYAN}Detected Distribution:${NC} $DISTRO"

# Package Definitions
# Required
PKGS_ARCH_REQ="rofi-wayland networkmanager qrencode dnsmasq ttf-jetbrains-mono-nerd"
PKGS_FEDORA_REQ="rofi-wayland NetworkManager qrencode dnsmasq"
PKGS_SUSE_REQ="rofi-wayland NetworkManager qrencode dnsmasq"

# Optional (for notifications)
PKGS_ARCH_OPT="libnotify"
PKGS_FEDORA_OPT="libnotify"
PKGS_SUSE_OPT="libnotify"

# Check Dependencies
DEPENDENCIES=("rofi" "nmcli" "qrencode" "dnsmasq")
# Note: Font detection is skipped (unreliable). User verification required.
MISSING_DEPS=()

echo ""
echo -e "${YELLOW}Checking required dependencies...${NC}"
for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        echo -e "  ${RED}✗ '$dep' is not installed.${NC}"
        MISSING_DEPS+=("$dep")
    else
        echo -e "  ${GREEN}✓ '$dep' found.${NC}"
    fi
done

# Install Missing Dependencies
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo ""
    if [ "$DISTRO" = "nixos" ]; then
        echo -e "${YELLOW}NixOS Detected.${NC} Please add the following to your configuration.nix:"
        echo -e "  ${GREEN}environment.systemPackages = with pkgs; [ rofi-wayland networkmanager qrencode dnsmasq libnotify (nerdfonts.override { fonts = [ \"JetBrainsMono\" ]; }) ];${NC}"
    elif [ "$DISTRO" != "unknown" ]; then
        read -p "Install missing dependencies using your package manager? [Y/n] " choice_install
        if [[ ! "$choice_install" =~ ^[Nn]$ ]]; then
            case "$DISTRO" in
                arch)
                    echo -e "${CYAN}Running: sudo pacman -S --needed $PKGS_ARCH_REQ $PKGS_ARCH_OPT${NC}"
                    sudo pacman -S --needed $PKGS_ARCH_REQ $PKGS_ARCH_OPT
                    ;;
                fedora)
                    echo -e "${CYAN}Running: sudo dnf install $PKGS_FEDORA_REQ $PKGS_FEDORA_OPT${NC}"
                    if [ -n "$PKGS_FEDORA_OPT" ]; then
                         sudo dnf install $PKGS_FEDORA_REQ $PKGS_FEDORA_OPT
                    else
                         sudo dnf install $PKGS_FEDORA_REQ
                    fi
                    echo -e "${YELLOW}Note: For Nerd Fonts on Fedora, you may need to enable a COPR repo or install manually.${NC}"
                    ;;
                suse)
                    echo -e "${CYAN}Running: sudo zypper install $PKGS_SUSE_REQ $PKGS_SUSE_OPT${NC}"
                    if [ -n "$PKGS_SUSE_OPT" ]; then
                        sudo zypper install $PKGS_SUSE_REQ $PKGS_SUSE_OPT
                    else
                        sudo zypper install $PKGS_SUSE_REQ
                    fi
                    echo -e "${YELLOW}Note: For Nerd Fonts on openSUSE, you may need to add a community repo or install manually.${NC}"
                    ;;
            esac
        fi
    else
        echo -e "${YELLOW}Could not detect your distribution.${NC}"
        echo "Please install the following packages manually: rofi-wayland, networkmanager, qrencode, dnsmasq, and a Nerd Font."
    fi
fi

# Setup Directories
INSTALL_DIR="$HOME/.local/bin"
THEME_DIR="$HOME/.config/rofi/themes"

echo ""
echo "Creating directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$THEME_DIR"

# Install Files
echo "Installing script to $INSTALL_DIR..."
cp hyprltm-net.sh "$INSTALL_DIR/hyprltm-net"
chmod +x "$INSTALL_DIR/hyprltm-net"

echo "Installing themes to $THEME_DIR..."
cp *.rasi "$THEME_DIR/"

# Configuration

# Desktop Entry
echo ""
echo -e "${YELLOW}[Desktop Entry]${NC} Adds HyprLTM-Net to your application launcher."
read -p "Create a Desktop Entry? [Y/n] " choice_desktop
if [[ ! "$choice_desktop" =~ ^[Nn]$ ]]; then
    ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"
    APP_DIR="$HOME/.local/share/applications"
    mkdir -p "$ICON_DIR"
    mkdir -p "$APP_DIR"
    cp hyprltm-net.svg "$ICON_DIR/hyprltm-net.svg"
    cat > "$APP_DIR/hyprltm-net.desktop" <<EOF
[Desktop Entry]
Name=HyprLTM-Net
Comment=Hyprland Network Manager
Exec=$INSTALL_DIR/hyprltm-net
Icon=hyprltm-net
Terminal=false
Type=Application
Categories=Network;System;
Keywords=network;manager;wi-fi;wireless;
EOF
    echo -e "${GREEN}Desktop Entry created.${NC}"
fi

# Hyprland Binding
echo ""
echo -e "${YELLOW}[Keybinding]${NC} Allows you to open the menu with SUPER+N."
read -p "Show instructions? [Y/n] " choice_keybind
if [[ ! "$choice_keybind" =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>> Add this line to ${CYAN}~/.config/hypr/hyprland.conf${NC}:"
    echo -e "   ${GREEN}bind = SUPER, N, exec, hyprltm-net${NC}"
fi

# Waybar Integration
echo ""
echo -e "${YELLOW}[Waybar]${NC} Makes the network module open this menu on click."
read -p "Show instructions? [Y/n] " choice_waybar
if [[ ! "$choice_waybar" =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>> Add this to the 'network' module in ${CYAN}~/.config/waybar/config.jsonc${NC}:"
    echo -e "   ${GREEN}\"on-click\": \"hyprltm-net\"${NC}"
fi

# Complete
echo ""
echo -e "${PURPLE}╔══════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║      ${GREEN}Installation Complete!${PURPLE}              ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Run from Terminal:${NC} hyprltm-net"
if [[ ! "$choice_desktop" =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}Run from Launcher:${NC} Search for 'HyprLTM-Net'"
fi
