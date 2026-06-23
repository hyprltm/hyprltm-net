#!/usr/bin/env bash
set -o pipefail
#    __  __                 __   ________  ___       _   __    __
#   / / / /_  ______  _____/ /  /_  __/  |/  /      / | / /___/ /_
#  / /_/ / / / / __ \/ ___/ /    / / / /|_/ /_____ /  |/ / _  / __/
# / __  / /_/ / /_/ / /  / /___ / / / /  / /_____ / /|  /  __/ /_
#/_/ /_/\__, / .___/_/  /_____//_/ /_/  /_/      /_/ |_/\___/\__/
#      /____/_/
#
# Copyright © 2025-2026 Djalel Oukid (sniper1720)

# Version: 0.5.0
# Description: A Rofi-based Network Manager for Hyprland (and others).

_mod_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/modules"
_script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

for _mod in i18n core profiles wifi ethernet hotspot airplane vpn speedtest; do
    source "$_mod_dir/$_mod.sh"
done
unset _mod _mod_dir

main_menu

