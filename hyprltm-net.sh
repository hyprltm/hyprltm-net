#!/usr/bin/env bash
#    __  __                 __   ________  ___       _   __    __ 
#   / / / /_  ______  _____/ /  /_  __/  |/  /      / | / /___/ /_
#  / /_/ / / / / __ \/ ___/ /    / / / /|_/ /_____ /  |/ / _  / __/
# / __  / /_/ / /_/ / /  / /___ / / / /  / /_____ / /|  /  __/ /_  
#/_/ /_/\__, / .___/_/  /_____//_/ /_/  /_/      /_/ |_/\___/\__/  
#      /____/_/                                                   
#

# Copyright © 2025-2026 Djalel Oukid (sniper1720)


# Version: 0.3.0
# Description: A Rofi-based Network Manager for Hyprland (and others).
# --- Dependencies Check ---
if ! command -v rofi &> /dev/null; then
    echo "Error: rofi is not installed. Please install it to use this script." >&2
    exit 1
fi
if ! command -v nmcli &> /dev/null; then
    echo "Error: nmcli is not installed. Please install NetworkManager and nmcli." >&2
    exit 1
fi

# =============================================================================
#                           CONFIGURATION & THEMING
# =============================================================================

ROFI_NETWORK_MANAGER_THEME="$HOME/.config/rofi/themes/hyprltm-net.rasi"

icon_search="${icon_search:-""}"
icon_close="${icon_close:-""}"
icon_check="${icon_check:-""}"
icon_on="${icon_on:-""}"
icon_off="${icon_off:-""}"
icon_info="${icon_info:-""}"
icon_refresh="${icon_refresh:-"󰑐"}"
icon_config="${icon_config:-""}"

icon_network="${icon_network:-"󱂇"}"
icon_wifi_prompt="${icon_wifi_prompt:-"󱚾"}"
icon_ethernet="${icon_ethernet:-"󰈀"}"
icon_vpn="${icon_vpn:-"󰖃"}"
icon_wireguard="${icon_wireguard:-"󰖆"}"
icon_bluetooth="${icon_bluetooth:-"󰂯"}"
icon_hotspot="${icon_hotspot:-"󱄙"}"
icon_airplane="${icon_airplane:-"󰀝"}"
icon_airplane_on="${icon_airplane_on:-"󱡻"}"
icon_airplane_off="${icon_airplane_off:-"󱢂"}"

icon_wifi_full="${icon_wifi_full:-"󰤨"}"
icon_wifi_good="${icon_wifi_good:-"󰤥"}"
icon_wifi_medium="${icon_wifi_medium:-"󰤢"}"
icon_wifi_low="${icon_wifi_low:-"󰤯"}"
icon_wifi_disconnected="${icon_wifi_disconnected:-"󰤫"}"
icon_wifi_enable="${icon_wifi_enable:-"󰖩"}"
icon_wifi_disable="${icon_wifi_disable:-"󰖪"}"

icon_wifi_secure="${icon_wifi_secure:-""}"
icon_wifi_open="${icon_wifi_open:-"󰤠"}"
icon_unlock="${icon_unlock:-""}"
icon_password="${icon_password:-""}"
icon_eye="${icon_eye:-"󰛐"}"
icon_eye_closed="${icon_eye_closed:-"󰛑"}"
icon_bookmark_saved="${icon_bookmark_saved:-"󰢭"}"
icon_saved="${icon_saved:-"󰢭"}"

icon_connect="${icon_connect:-"󰚫"}"
icon_disconnect="${icon_disconnect:-"󰚬"}"
icon_vpn_disconnect="${icon_vpn_disconnect:-"󰖂"}"
icon_trash="${icon_trash:-""}"
icon_pen="${icon_pen:-"󰑕"}"
icon_import="${icon_import:-"󰋺"}"
icon_qrcode="${icon_qrcode:-"󰐲"}"

icon_active_details="${icon_active_details:-"󰋼"}"
icon_status_chart="${icon_status_chart:-"󱖫"}"
icon_interface="${icon_interface:-"󰛨"}"
icon_devices="${icon_devices:-"󰋽"}"
icon_chip="${icon_chip:-"󰢮"}"
icon_ipv4_config="${icon_ipv4_config:-"󰒓"}"
icon_ipv4_dns="${icon_ipv4_dns:-"󰒍"}"
icon_ipv6_config="${icon_ipv6_config:-"󰒓"}"
icon_ipv6_dns="${icon_ipv6_dns:-"󰒍"}"
icon_auto_ip="${icon_auto_ip:-"󰑘"}"
icon_auto_dns="${icon_auto_dns:-"󰒍"}"
icon_address="${icon_address:-"󰒓"}"
icon_gateway="${icon_gateway:-"󰞡"}"
icon_plug="${icon_plug:-"󱘖"}"
icon_wireless="${icon_wireless:-"󰑩"}"
icon_automatic="${icon_automatic:-"󰑘"}"

icon_hidden_network="${icon_hidden_network:-"󰲊"}"
icon_connect_wired="${icon_connect_wired:-"󱂇"}"
icon_wired_status="${icon_wired_status:-"󰈁"}"

# =============================================================================
#                               TRANSLATIONS
# =============================================================================

tr_checking_wifi_status='Checking Wi-Fi status... Please be patient.'
tr_scanning_networks='Scanning networks... Please be patient.'
tr_connecting_to='Connecting to'
tr_disconnecting_from='Disconnecting from'
tr_please_wait='... Please be patient.'
tr_submenu_message='More options'
tr_disable_message='Disable Wi-Fi'
tr_enable_message='Enable Wi-Fi'
tr_interface_message='Interface:'
tr_known_connections_message='Known connections'
tr_available_networks_message='Available Networks'
tr_available_vpn_profiles_message='Available VPN Profiles'
tr_autoconnect_message='Autoconnect'
tr_ipv4_config_message='IPv4 Configuration'
tr_ipv6_config_message='IPv6 Configuration'
tr_dns4_message='DNS IPv4'
tr_dns6_message='DNS IPv6'
tr_connection_details_message='Connection Details'
tr_ip_addr='IP Address'
tr_gateway='Gateway'
tr_signal_strength='Signal Strength'
tr_speed='Link Speed'
tr_frequency='Frequency'
tr_mac_addr='MAC Address'
tr_device='Interface'
tr_autoip_message='Automatic IP'
tr_autodns_message='Automatic DNS'
tr_address_message='Addresses'
tr_gateway_message='Gateway:'
tr_forget_message='Forget connection'
tr_wireguard_enable_message='Toggle VPN'
tr_rename_connection_message='Rename connection'
tr_hidden_message='Connect to a hidden network'
tr_refresh_scan_message='Refresh Scan'
tr_no_known_wifi_connections='No known Wi-Fi connections.'
tr_no_configured_vpns='No VPN connections configured.'
tr_no_active_vpns='No active VPN connections.'
tr_no_saved_connections='No saved connections found.'
tr_no_active_connection='No active connection.'
tr_no_ethernet_device='No Ethernet device found.'
tr_no_wifi_networks_found='No Wi-Fi networks found.'
tr_wired_status_message='Wired Status'
tr_manage_wired_profile='Manage Active Wired Profile'
tr_hotspot_menu_prompt="Hotspot Manager"
tr_connect_wired_connection='Connect to Wired Connection:'
tr_manage_wired_connections='Manage Wired Connections'
tr_import_vpn_message='Import VPN from file'
tr_import_vpn_prompt='Enter full path to .conf or .ovpn file:'
tr_status_message='Status:'
tr_status_connected_to='Connected to'
tr_status_connected='Connected'
tr_status_disconnected='Disconnected'

tr_status_disabled='Disabled'
tr_connect_now_message='Connect Now'
tr_disconnect_message='Disconnect Now'
tr_notice_import_success_summary='VPN Imported'
tr_notice_import_success_body='Successfully imported VPN connection.'
tr_notice_import_error_summary='Import Error'
tr_notice_import_error_body='Failed to import VPN connection.'
tr_notice_file_not_found_body='File not found at specified path.'

tr_airplane_mode_message='Airplane Mode'
tr_airplane_on='Airplane Mode Enabled'
tr_airplane_off='Airplane Mode Disabled'

tr_edit_password_message='Edit Password'
tr_password_prompt='Enter password for'
tr_password_updated='Password Updated'
tr_password_update_failed='Failed to update password'
tr_connection_failed_retry='Connection failed. Update password?'
tr_qrcode_message='Share via QR Code'
tr_qrcode_generating='Generating QR Code...'
tr_qrcode_error='Could not generate QR code. Is qrencode installed?'
tr_qrcode_no_password='Cannot share network without saved password.'

tr_hotspot_message='Create Hotspot'
tr_hotspot_ssid_prompt='Enter Hotspot SSID:'
tr_hotspot_password_prompt='Enter Hotspot Password (min 8 chars):'
tr_hotspot_creating='Creating Hotspot...'
tr_hotspot_success='Hotspot created successfully!'
tr_hotspot_error='Failed to create hotspot.'
tr_notice_unknown_vpn_type_body='Unknown VPN file type. Use .conf or .ovpn.'

tr_main_menu_prompt="$icon_network Network Manager: $icon_search"
tr_wifi_menu_prompt="$icon_wifi_prompt Wi-Fi: $icon_search"
tr_wired_menu_prompt="$icon_ethernet Wired: $icon_search"
tr_vpn_menu_prompt="$icon_vpn_disconnect VPN: $icon_search"
tr_saved_connections_menu_prompt="$icon_bookmark_saved Saved Connections: $icon_search"
tr_status_menu_prompt="$icon_status_chart Status: $icon_search"

tr_select_interface_prompt='Select Interface:'
tr_ask_password_prompt='Enter password:'
tr_menu_dns_prompt='Enter DNS (e.g., 8.8.8.8):'
tr_menu_dns_sure_prompt_1='Remove DNS '
tr_menu_dns_sure_prompt_2='?'
tr_menu_ip_config_addresses_prompt='Enter address (e.g., 192.168.1.10/24):'
tr_menu_ip_config_gateway_prompt='Enter gateway (e.g., 192.168.1.1):'
tr_menu_addresses_prompt='Type or select address (e.g., 192.168.1.10/24):'
tr_menu_addresses_sure_prompt_1='Remove address '
tr_menu_addresses_sure_prompt_2='?'
tr_forget_connection_sure_prompt_1='Forget '
tr_forget_connection_sure_prompt_2='?'
tr_forget_connection_confirm='Yes, forget'
tr_rename_connection_prompt='Enter new name for connection:'
tr_connect_hidden_prompt='Enter hidden network name:'

tr_notice_connected_summary='Connected'
tr_notice_disconnected_summary='Disconnected'
tr_notice_error_summary='Connection Error'
tr_notice_connected_body='Successfully connected to'
tr_notice_disconnected_body='Successfully disconnected from'
tr_notice_error_body='Failed to connect to'
tr_notice_error_disconnect_body='Failed to disconnect from'

tr_show_password_message='Show Password'
tr_hide_password_message='Hide Password'
tr_confirm_password_message='Confirm Password'
tr_edit_password_message='Edit Password'
tr_edit_password_prompt='Enter new password:'
tr_password_updated_summary='Password Updated'
tr_password_updated_body='Password updated successfully for'
tr_password_update_failed_summary='Update Failed'
tr_password_update_failed_body='Failed to update password for'

program_name="$(basename "$0")"
LOADING_ROFI_PID=""
mapfile -t interfaces < <(nmcli --colors no -t -f TYPE,DEVICE device status | awk -F ':' '$1 == "wifi" {print $2}')
if [ -z "${interfaces[0]}" ]; then
	echo "$program_name: No Wi-Fi interfaces detected." >&2
	exit 2
fi
interface_to_use="${interfaces[0]}"

# =============================================================================
#                               ROFI WRAPPERS
# =============================================================================

display_menu() {
	local form="$1"
	local prompt_text="$2"
	local prompt_icon="${3:-}"
    local extra_flags="${4:-}"
    local rofi_prompt rofi_flags options_list

	if [ -n "$prompt_icon" ] && ! echo "$prompt_text" | grep -qE "^$prompt_icon"; then
		rofi_prompt="$prompt_icon $prompt_text"
	else
		rofi_prompt="$prompt_text"
	fi

	local result

	case $form in
		1)
            rofi_flags="-dmenu -i"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME")
            ;;
		2)
            rofi_flags="-dmenu"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME")
            ;;
		3)
            rofi_flags="-dmenu -password"
            result=$(rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#listview { enabled: false; }')
            ;;
        4)
            rofi_flags="-dmenu -i"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#inputbar { enabled: false; }')
            ;;
        5)
            rofi_flags="-dmenu"
            result=$(rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#listview { enabled: false; }')
            ;;
	esac
	echo "$result"
}

show_loading_notification() {
    local message="$1"

    echo "" | rofi -dmenu -p "" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -theme-str 'mainbox { children: [textbox]; }' \
        -theme-str 'textbox { str: "'"$message"'"; horizontal-align: 0.5; vertical-align: 0.5; background-color: transparent; text-color: @on-primary-fixed; padding: 8px 15px; }' &
    LOADING_ROFI_PID=$!
}

# =============================================================================
#                             HELPER FUNCTIONS
# =============================================================================

clean_error_message() {
    local raw_msg="$1"
    local clean_msg=""
    local icon="❌"

    raw_msg="${raw_msg%%Hint:*}"

    raw_msg="${raw_msg#Error: }"

    raw_msg="$(echo "$raw_msg" | xargs)"

    case "$raw_msg" in
        *"Secrets were required"*)
            icon=""
            clean_msg="Incorrect password or missing credentials."
            ;;
        *"No network with SSID"*|*"network could not be found"*)
            icon="󰐷"
            clean_msg="Network not found. It may be out of range."
            ;;
        *"activation failed"*)
             icon="⚠️"
             clean_msg="Connection failed. The network refused the connection."
             ;;
        *"Timeout"*)
             icon="⏳"
             clean_msg="Connection timed out. The network is too slow or unreachable."
             ;;
        *"cancelled"*)
             icon="🚫"
             clean_msg="Operation cancelled."
             ;;
        *)
            clean_msg="$raw_msg"
            ;;
    esac

    echo "$icon $clean_msg"
}

show_error_dialog() {
    local raw_error="$1"
    local clean_msg=$(clean_error_message "$raw_error")

    local options="$icon_refresh Try Again\n$icon_password Edit Password\n$icon_close Cancel"

    echo -e "$options" | rofi -dmenu -i -p "⚠️ Connection Failed" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -mesg "$clean_msg" \
        -theme-str 'listview { lines: 3; }' \
        -theme-str 'mainbox { children: [inputbar, message, listview]; }' \
        -theme-str 'message { border-color: @error-message; }' \
        -theme-str 'textbox { text-color: @error-message; }'
}

show_warning_dialog() {
    local title="$1"
    local message="$2"
    local options="$icon_check Proceed"

    local full_msg=$(echo -e "$title: $message")

    echo -e "$options" | rofi -dmenu -i \
        -name "warning_dialog" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -mesg "$full_msg" \
        -theme-str 'listview { lines: 1; }' \
        -theme-str 'mainbox { children: [message, listview]; }' \
        -theme-str 'inputbar { enabled: false; }' \
        -theme-str 'message { border-color: @warning-message; }' \
        -theme-str 'textbox { text-color: @warning-message; }'
}

show_success_dialog() {
    local title="$1"
    local message="$2"
    local options="$icon_check OK"

    local full_msg=$(echo -e "$title: $message")

    echo -e "$options" | rofi -dmenu -i \
        -name "success_dialog" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -mesg "$full_msg" \
        -theme-str 'listview { lines: 1; }' \
        -theme-str 'mainbox { children: [message, listview]; }' \
        -theme-str 'inputbar { enabled: false; }' \
        -theme-str 'message { border-color: @success-message; }' \
        -theme-str 'textbox { text-color: @success-message; }'
}

kill_loading_notification() {
    if [ -n "$LOADING_ROFI_PID" ] && ps -p "$LOADING_ROFI_PID" > /dev/null; then
        kill "$LOADING_ROFI_PID"
        LOADING_ROFI_PID=""
    fi
}

send_notification() {
    local summary="$1"
    local body="$2"
    local type="${3:-normal}"

    if is_notification_service_running && command -v notify-send &> /dev/null; then
        local urgency="normal"
        if [ "$type" = "error" ]; then
             urgency="critical"
        fi
        notify-send -u "$urgency" -a "HyprLTM-Net" -i "network-wireless" "$summary" "$body"
    else

        if [ "$type" = "error" ]; then
             show_error_message "❌ $body"
        else

             show_success_message "$icon_check $body"
        fi
    fi
}

show_message() {
    local msg="$1"
    local custom_prompt="${2:-Info}"
    local include_ok="${3:-true}"
    local options="$msg"

    if [ "$include_ok" = "true" ]; then
        options+="\n$icon_check OK"
    fi

    echo -e "$options" | display_menu 4 "$custom_prompt" ""
}

display_info_message() {
    local icon="${3:-$icon_info}"
    local msg="$icon $1"
    local custom_prompt="${2:-Info}"
    local options="$icon_close Back"

    echo -e "$options" | rofi -dmenu -i \
        -p "$custom_prompt" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -mesg "$msg" \
        -theme-str 'listview { lines: 1; }' \
        -theme-str 'mainbox { children: [message, listview]; }' \
        -theme-str 'inputbar { enabled: false; }' \
        -theme-str 'message { border-color: @info-message; }' \
        -theme-str 'textbox { text-color: @info-message; }' 

    return 0
} 

is_notification_service_running() {
    if busctl --user list | grep -qE "org.freedesktop.Notifications"; then
        return 0
    else
        return 1
    fi
}

show_success_message() {
    local message="$1"
    local options="$icon_check OK"

    echo -e "$options" | rofi -dmenu -i \
        -name "success_dialog" \
        -p "Success" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -mesg "$message" \
        -theme-str 'listview { lines: 1; }' \
        -theme-str 'mainbox { children: [message, listview]; }' \
        -theme-str 'inputbar { enabled: false; }' \
        -theme-str 'message { border-color: @success-message; }' \
        -theme-str 'textbox { text-color: @success-message; }'
}

show_error_message() {
    local message="$1"
    local options="$icon_close OK"

    echo -e "$options" | rofi -dmenu -i \
        -name "error_dialog" \
        -p "Error" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -mesg "$message" \
        -theme-str 'listview { lines: 1; }' \
        -theme-str 'mainbox { children: [message, listview]; }' \
        -theme-str 'inputbar { enabled: false; }' \
        -theme-str 'message { border-color: @error-message; }' \
        -theme-str 'textbox { text-color: @error-message; }'
}

ask_password() {
    local password_input
    local password_shown="false"

    password_input=$(echo "" | display_menu 3 "$tr_ask_password_prompt" "")

    if [ -z "$password_input" ]; then
        return 1
    fi

    while true; do
        local options=""
        local password_display=""

        if [ "$password_shown" = "true" ]; then
            password_display="$password_input"
            options+="$icon_eye_closed $tr_hide_password_message: $password_display\n"
        else

            password_display=$(printf '•%.0s' $(seq 1 ${#password_input}))
            options+="$icon_eye $tr_show_password_message: $password_display\n"
        fi

        options+="$icon_pen $tr_edit_password_message\n"
        options+="$icon_unlock $tr_confirm_password_message\n"
        options+="$icon_close Back"

        local action_choice=$(echo -e "$options" | display_menu 1 "Password Actions" "")

        if [ -z "$action_choice" ] || [[ "$action_choice" =~ ^"$icon_close Back" ]]; then

            return 1
        fi

        case "$action_choice" in
            *"$tr_show_password_message"*|*"$tr_hide_password_message"*)

                if [ "$password_shown" = "true" ]; then
                    password_shown="false"
                else
                    password_shown="true"
                fi

                ;;
            *"$tr_edit_password_message"*)

                local new_password=$(echo "" | display_menu 2 "$tr_edit_password_prompt" "" "-filter \"$password_input\"")

                if [ -n "$new_password" ]; then
                    password_input="$new_password"
                    password_shown="false"
                fi

                ;;
            *"$tr_confirm_password_message"*)

                echo "$password_input"
                return
                ;;
        esac
    done
}

show_connection_details() {
    local active_ssid="$1"
    local device="$2"

    show_loading_notification "Gathering details..."

    local info=$(nmcli -t -f GENERAL,IP4,IP6 device show "$device")

    local ipv4=$(echo "$info" | grep "IP4.ADDRESS\[1\]" | cut -d':' -f2)
    local gateway=$(echo "$info" | grep "IP4.GATEWAY" | cut -d':' -f2)
    local hwaddr=$(echo "$info" | grep "GENERAL.HWADDR" | sed 's/^GENERAL.HWADDR://')
    local state=$(echo "$info" | grep "GENERAL.STATE" | cut -d':' -f2)

    local wifi_info=$(nmcli -t -f IN-USE,SSID,MODE,CHAN,RATE,SIGNAL,BARS,SECURITY device wifi list | grep "^\*")

    local chan=$(echo "$wifi_info" | cut -d':' -f4)
    local rate=$(echo "$wifi_info" | cut -d':' -f5)
    local signal=$(echo "$wifi_info" | cut -d':' -f6)
    local bars=$(echo "$wifi_info" | cut -d':' -f7)
    local freq=""

    if [ "$chan" -gt 14 ]; then freq="5 GHz"; else freq="2.4 GHz"; fi

    kill_loading_notification

    local details=""
    details+="$icon_address $tr_ip_addr: $ipv4\n"
    details+="$icon_gateway $tr_gateway: $gateway\n"
    details+="$icon_wifi_full $tr_signal_strength: $signal% ($bars)\n"
    details+="$icon_on $tr_speed: $rate\n"
    details+="$icon_wireless $tr_frequency: $freq (Ch $chan)\n"
    details+="$icon_devices $tr_mac_addr: $hwaddr\n"
    details+="$icon_chip $tr_device: $device"

    echo -e "$details\n$icon_close Back" | display_menu 1 "$tr_connection_details_message" ""
}

perform_wifi_scan() {
    show_loading_notification "$tr_scanning_networks"

    local known_ssids=$(nmcli -t -f 802-11-wireless.ssid connection show | tr '\n' '|')

    known_ssids="|$known_ssids"

    local scan_output=$(nmcli --colors no --get-values SECURITY,SIGNAL,SSID,IN-USE device wifi list --rescan auto | awk -F ':' \
        -v icon_wifi_secure="$icon_wifi_secure" \
        -v icon_wifi_open="$icon_wifi_open" \
        -v icon_wifi_full="$icon_wifi_full" \
        -v icon_wifi_good="$icon_wifi_good" \
        -v icon_wifi_medium="$icon_wifi_medium" \
        -v icon_wifi_low="$icon_wifi_low" \
        -v icon_check="$icon_check" \
        -v icon_unlock="$icon_unlock" \
        -v known_ssids="$known_ssids" \
    '
    BEGIN { x = 1 }
    {

        wifi_signal_icon = icon_wifi_low;
        if ($2 > 75) wifi_signal_icon = icon_wifi_full;
        else if ($2 > 50) wifi_signal_icon = icon_wifi_good;
        else if ($2 > 25) wifi_signal_icon = icon_wifi_medium;

        ssid = $3;
        if (ssid == "") ssid = "<hidden>";

        status_icon = icon_unlock;

        if ($4 == "*") {
             status_icon = icon_check;
        } else if ($1 ~ /^WPA/) {
             status_icon = icon_wifi_secure;
        } 

        formatted_entry = wifi_signal_icon " " status_icon " " ssid " (" $2 "%)";

        if ($4 == "*") {
            networks[0] = formatted_entry;
        } else {
            networks[x++] = formatted_entry;
        }
    }
    END {
        if (networks[0] != "") {
            print networks[0];
        }
        for (i = 1; i < x; i++) {
            print networks[i];
        }
    }
    ')
    kill_loading_notification
    echo "$scan_output"
}

menu_available_wifi_networks() {
    local wifi_list options chosen
    while true; do
        wifi_list=$(perform_wifi_scan)

        options="$icon_refresh  $tr_refresh_scan_message\n"
        if [ -z "$wifi_list" ]; then
            options+="$icon_wifi_disconnected  $tr_no_wifi_networks_found\n"
        else
            options+="$wifi_list\n"
        fi
        options+="$icon_close Back"

        chosen=$(echo -e "$options" | display_menu 1 "$tr_available_networks_message" "$icon_search")

        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$chosen" in
            "$icon_refresh  $tr_refresh_scan_message")
                continue
                ;;
            "$icon_wifi_disconnected  $tr_no_wifi_networks_found")

                continue
                ;;
            *)

                connect_wifi "$chosen"
                ;;
        esac
    done
}

menu_manage_hotspot_profile() {
    local uuid="$1"
    local name="$2"

    while true; do

        local is_active=$(nmcli -t -f UUID,STATE connection show --active | grep "$uuid" | grep -q "activated" && echo "yes" || echo "no")
        local toggle_icon="$([ "$is_active" = "yes" ] && echo "$icon_on" || echo "$icon_off")"
        local toggle_text="$([ "$is_active" = "yes" ] && echo "Stop Hotspot" || echo "Enable Hotspot")"

        local options=""
        options+="$icon_hotspot  $toggle_text  $toggle_icon\n"
        options+="$icon_password  $tr_edit_password_message\n"
        options+="$icon_pen  $tr_rename_connection_message\n"
        options+="$icon_qrcode  $tr_qrcode_message\n"
        options+="$icon_trash  Delete Hotspot Profile\n"
        options+="$icon_close Back"

        local chosen=$(echo -e "$options" | display_menu 1 "Manage '$name'" "$icon_hotspot")

        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$chosen" in
            *"$toggle_text"*)
                if [ "$is_active" = "yes" ]; then
                    show_loading_notification "Stopping Hotspot..."
                    nmcli connection down uuid "$uuid"
                    kill_loading_notification
                else

                     local active_wifi=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ":wifi:${interface_to_use}")
                     if [ -n "$active_wifi" ]; then
                        if ! show_warning_dialog "⚠️ Wi-Fi Disconnect Required" "Starting Hotspot will disconnect current Wi-Fi.\nProceed?"; then continue; fi
                        nmcli device disconnect "$interface_to_use" &> /dev/null
                     fi

                    show_loading_notification "Starting Hotspot..."
                    if nmcli connection up uuid "$uuid"; then
                        kill_loading_notification
                        send_notification "Hotspot Started" "Active: $name"
                    else
                        kill_loading_notification
                        show_message "Failed to start hotspot."
                    fi
                fi
                ;;
            *"$tr_edit_password_message"*)
                edit_connection_password "$uuid" "$name"
                name=$(nmcli -g connection.id connection show "$uuid")
                ;;
            *"$tr_rename_connection_message"*)
                 if rename_connection "$uuid"; then
                    name=$(nmcli -g connection.id connection show "$uuid")
                 fi
                ;;
            *"$tr_qrcode_message"*)
                local sec=$(nmcli -g 802-11-wireless-security.key-mgmt connection show "$uuid" | sed 's/wpa-psk/WPA/')
                local pass=$(nmcli -s -g 802-11-wireless-security.psk connection show "$uuid")
                show_qrcode "$name" "$sec" "$pass"
                ;;
            *"Delete Hotspot Profile"*)
                if forget_connection "$name" "$uuid"; then
                    show_message "Hotspot profile deleted."
                    return
                fi
                ;;
        esac
    done
}

menu_saved_hotspots() {
    while true; do

        local wifi_profiles=$(nmcli -t -f UUID,NAME,TYPE connection show | grep ":802-11-wireless")

        local hotspot_list=()

        while IFS=':' read -r uuid name type; do
            if [ -z "$uuid" ]; then continue; fi
            local mode=$(nmcli -g 802-11-wireless.mode connection show "$uuid" 2>/dev/null)
            if [ "$mode" = "ap" ]; then

                hotspot_list+=("$uuid;;;$name")
            fi
        done <<< "$wifi_profiles"

        if [ "${#hotspot_list[@]}" -eq 0 ]; then
            display_info_message "No saved hotspot profiles found." "Saved Hotspots"
            return
        fi

        local options=""
        for item in "${hotspot_list[@]}"; do
             local name=$(echo "$item" | awk -F';;;' '{print $2}')
             options+="$icon_hotspot  $name\n"
        done
        options+="$icon_close Back"

        local chosen_index=$(echo -e "$options" | display_menu 1 "Saved Hotspots" "$icon_hotspot" "-format i")

        if [ -z "$chosen_index" ]; then
            return
        fi

        if [ "$chosen_index" -eq "${#hotspot_list[@]}" ]; then
             return
        fi

        local selected_item="${hotspot_list[$chosen_index]}"
        local uuid=$(echo "$selected_item" | awk -F';;;' '{print $1}')
        local name=$(echo "$selected_item" | awk -F';;;' '{print $2}')

        menu_manage_hotspot_profile "$uuid" "$name"
    done
}

menu_hotspot() {
    while true; do

        local active_hotspot_uuid=$(nmcli -t -f UUID,DEVICE,TYPE connection show --active | grep ":${interface_to_use}:" | grep ":802-11-wireless" | cut -d':' -f1)

        local is_ap_active="no"
        local active_ssid=""
        if [ -n "$active_hotspot_uuid" ]; then
             local mode=$(nmcli -g 802-11-wireless.mode connection show "$active_hotspot_uuid" 2>/dev/null)
             if [ "$mode" = "ap" ]; then
                is_ap_active="yes"
                active_ssid=$(nmcli -g 802-11-wireless.ssid connection show "$active_hotspot_uuid")
             fi
        fi

        local options=""
        local status_line=""

        if [ "$is_ap_active" = "yes" ]; then
            status_line="$icon_on  Status: Active ($active_ssid)\n"
        else
            status_line="$icon_off  Status: Inactive\n"
        fi

        options+="$icon_bookmark_saved  Manage Saved Hotspots\n"

        options+="$icon_hotspot  Create New Hotspot\n"

        options+="$icon_close Back"

        local header="$status_line"
        local chosen=$(echo -e "$options" | display_menu 1 "$tr_hotspot_menu_prompt" "$icon_hotspot")

        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$chosen" in
            *"Create New Hotspot"*)
                create_hotspot
                ;;
            *"Manage Saved Hotspots"*)
                menu_saved_hotspots
                ;;
        esac
    done
}

# =============================================================================
#                              WI-FI MENU CONTROLLER
# =============================================================================

menu_wifi() {
	local connection_state options chosen
	while true; do
        show_loading_notification "$tr_checking_wifi_status"
		connection_state=$(nmcli --colors no --get-values WIFI general)

        local active_uuid=$(nmcli -t -f UUID,DEVICE connection show --active | grep ":${interface_to_use}$" | cut -d':' -f1 | head -n 1)

        local active_ssid=""
        local is_ap_mode="no"

        if [ -n "$active_uuid" ]; then

            active_ssid=$(nmcli -g 802-11-wireless.ssid connection show "$active_uuid")
            local mode=$(nmcli -g 802-11-wireless.mode connection show "$active_uuid")
            if [ "$mode" = "ap" ]; then is_ap_mode="yes"; fi

             if [ -z "$active_ssid" ]; then active_ssid=$(nmcli -g connection.id connection show "$active_uuid"); fi
        fi

        kill_loading_notification

        local status_line=""
		if [ "$connection_state" = "disabled" ]; then
            status_line="$icon_wifi_disable $tr_status_message $tr_status_disabled"
			options="$icon_wifi_enable  $tr_enable_message\n"
		else
            if [ -n "$active_uuid" ]; then
                if [ "$is_ap_mode" = "yes" ]; then

                     status_line="$icon_hotspot $tr_status_message Hotspot Active: '$active_ssid' (${interface_to_use})"
                else

                     status_line="$icon_wifi_full $tr_status_message $tr_status_connected_to '$active_ssid' (${interface_to_use})"
                fi
            else
                status_line="$icon_wifi_disconnected $tr_status_message $tr_status_disconnected"
            fi
			options="$icon_wifi_disable  $tr_disable_message\n"
			${interfaces[1]:+options+="$icon_interface  $tr_interface_message ${interface_to_use}\n"}

            options+="$icon_wireless  $tr_available_networks_message\n"
		fi

        local full_options="$status_line\n"
        full_options+="$options"
        full_options+="$icon_hotspot  Hotspot Manager\n"
        full_options+="$icon_bookmark_saved  $tr_known_connections_message\n"
        full_options+="$icon_hidden_network  $tr_hidden_message\n"
        full_options+="$icon_close Back"

		chosen=$(echo -e "$full_options" | display_menu 1 "$tr_wifi_menu_prompt" "")

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

		case "$chosen" in
            "$icon_wifi_enable  $tr_enable_message")
				nmcli radio wifi on
				;;
			"$icon_wifi_disable  $tr_disable_message")
				nmcli radio wifi off
				;;
			*"$tr_interface_message"*) select_interface ;;
            "$icon_wireless  $tr_available_networks_message") menu_available_wifi_networks ;;
			*"$tr_known_connections_message"*) menu_known_connections "wifi" ;;
			*"$tr_hidden_message"*) connect_hidden ;;
            *"Hotspot Manager"*) menu_hotspot ;;
            *"$tr_status_message"*) 

                if [ -n "$active_uuid" ]; then
                    show_connection_details "$active_ssid" "${interface_to_use}"
                fi
                ;;
			*)
                show_message "Invalid option selected: $chosen"
                ;;
		esac
	done
}

select_interface() {
	local chosen_interface=$( (for (( i = 0; i < ${#interfaces[@]}; i++ )); do echo "$icon_interface  ${interfaces[$i]}" ; done; echo "$icon_close Back") | display_menu 1 "$tr_select_interface_prompt" "")

	if [ -z "$chosen_interface" ]; then
		return
	elif [[ "$chosen" =~ ^"$icon_close Back" ]]; then
		return
	else
		interface_to_use="${chosen_interface:3}"
	fi
}

connect_hidden() {
	local wifi_name=$(echo "" | display_menu 5 "$tr_connect_hidden_prompt" "")

	if [ -z "$wifi_name" ]; then
		return
	fi

	local wifi_password=$(ask_password)

	if [ -z "$wifi_password" ]; then
		show_message "Connection cancelled. No password provided."
		return
	fi

    while true; do
        show_loading_notification "$tr_connecting_to '$wifi_name'$tr_please_wait"
        output=$(nmcli --wait 15 device wifi connect "$wifi_name" hidden yes password "$wifi_password" 2>&1)

        if [ $? -eq 0 ]; then
            kill_loading_notification
            send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$wifi_name'"
            exit 0
        else
            kill_loading_notification

            local choice=$(show_error_dialog "$output")
            case "$choice" in
                *"Try Again") continue ;;
                *"Edit Password")
                     wifi_password=$(ask_password)
                     if [ -z "$wifi_password" ]; then break; fi
                     continue
                     ;;
                *) 
                     send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$wifi_name'" "error"
                     break 
                     ;;
            esac
        fi
    done
}

connect_wifi() {
	local chosen_entry="$1"

    if [[ "$chosen_entry" == *"$icon_check"* ]]; then
        local ssid_from_active=$(nmcli -t -f active,ssid dev wifi | grep "^yes" | cut -d':' -f2)
        local active_uuid=$(nmcli -t -f UUID,TYPE,ACTIVE connection show | grep ":802-11-wireless:yes" | cut -d':' -f1 | head -n1)

        if [ -n "$active_uuid" ]; then
             if [ -z "$ssid_from_active" ]; then
                local temp_ssid=$(echo "$chosen_entry" | sed -E 's/ \([0-9]+%\).*$//')
                ssid_from_active=$(echo "$temp_ssid" | sed -E 's/^(󰄬 |󰤫 |󰤪 |󰤩 |󰤨 |󰤧 |󰤦 |󰤥 |󰤤 |󰤣 |󰤢 |󰤡 |󰤠 )+//' | xargs)
             fi
             menu_connection "$ssid_from_active" "$active_uuid"
             return
        fi
    fi

    local temp_ssid=$(echo "$chosen_entry" | sed -E 's/ \([0-9]+%\).*$//')
    local wifi_ssid=$(echo "$temp_ssid" | sed -E 's/^(󰤨 |󰤥 |󰤢 |󰤯 |󰤫 |󰤪 | | | )+//' | xargs)

	local is_secure=$(echo "$chosen_entry" | grep -q "$icon_wifi_secure" && echo "yes" || echo "no")

	local active_ssid=$(nmcli -t -f active,ssid dev wifi | grep "^yes" | cut -d':' -f2)
	if [ "$wifi_ssid" = "$active_ssid" ]; then
        local active_uuid=$(nmcli -t -f UUID,TYPE,ACTIVE connection show | grep ":802-11-wireless:yes" | cut -d':' -f1 | head -n1)
        if [ -n "$active_uuid" ]; then
             menu_connection "$wifi_ssid" "$active_uuid"
             return
        fi
		show_message "Already connected to $wifi_ssid."
		return
	fi

    local saved_uuid=""

    local saved_list=$(nmcli -t -f UUID,TYPE connection show)

    while IFS=: read -r uuid type; do

        if [[ "$type" == "802-11-wireless" || "$type" == "wifi" ]]; then

            local ssid_check=$(nmcli -t -f 802-11-wireless.ssid connection show "$uuid" 2>/dev/null)

            ssid_check="${ssid_check#*:}"

            if [ "$ssid_check" = "$wifi_ssid" ]; then
                saved_uuid="$uuid"
                break
            fi
        fi
    done <<< "$saved_list"

    if [ -n "$saved_uuid" ]; then
        menu_connection "$wifi_ssid" "$saved_uuid"
        return
    fi

    local connection_result
	if [ "$is_secure" = "yes" ]; then
		local wifi_password=$(ask_password)
		if [ -z "$wifi_password" ]; then
			show_message "Connection cancelled. No password provided."
			return
		fi
    fi

    while true; do

        local existing_uuid=""

        nmcli -t -f UUID,NAME,802-11-wireless.ssid connection show | while IFS=: read -r uuid name ssid; do

            if [ "$ssid" = "$wifi_ssid" ]; then
                echo "$uuid" > /tmp/hyprltm_uuid_found
                break
            fi

            if [ "$name" = "$wifi_ssid" ]; then
                echo "$uuid" > /tmp/hyprltm_uuid_found
                break
            fi
        done

        if [ -f /tmp/hyprltm_uuid_found ]; then
            existing_uuid=$(cat /tmp/hyprltm_uuid_found)
            rm /tmp/hyprltm_uuid_found
        fi

        show_loading_notification "$tr_connecting_to '$wifi_ssid'$tr_please_wait"

        local output
        local connection_result

        if [ -n "$existing_uuid" ]; then

            output=$(nmcli connection up uuid "$existing_uuid" 2>&1)
            connection_result=$?
        else

            if [ "$is_secure" = "yes" ]; then

                nmcli connection delete id "$wifi_ssid" &>/dev/null
                sleep 0.5

                nmcli connection add type wifi con-name "$wifi_ssid" ssid "$wifi_ssid" ifname "$interface_to_use" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$wifi_password" &>/dev/null

                output=$(nmcli connection up id "$wifi_ssid" 2>&1)
                connection_result=$?
            else

                nmcli connection delete id "$wifi_ssid" &>/dev/null
                output=$(nmcli --wait 15 device wifi connect "$wifi_ssid" ifname "$interface_to_use" 2>&1)
                connection_result=$?
            fi
        fi

        kill_loading_notification

        if [ $connection_result -eq 0 ]; then
            send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$wifi_ssid'"
            exit 0
        else

            local choice=$(show_error_dialog "$output")
            case "$choice" in
                *"Try Again") continue ;;
                *"Edit Password")
                    if [ "$is_secure" = "yes" ]; then
                        if [ -n "$existing_uuid" ]; then

                             edit_connection_password "$existing_uuid" "$wifi_ssid"
                        else

                             wifi_password=$(ask_password)
                             if [ -z "$wifi_password" ]; then break; fi
                        fi
                        continue
                    else
                        continue
                    fi
                    ;;
                *) 
                    send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$wifi_ssid'" "error"
                    break 
                    ;;
            esac
        fi
    done

}

# =============================================================================
#                            IP CONFIGURATION & MENUS
# =============================================================================

menu_addresses() {
	local connection_uuid="$1"
	local ipv="$2"
	local -a addresses_list
	local sure chosen

	while true; do
		mapfile -t addresses_list < <(nmcli --get-values ipv${ipv}.addresses connection show "$connection_uuid" | sed 's/,/\n/g')
		local options=$(printf "%s\n" "${addresses_list[@]}")
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$tr_menu_addresses_prompt" "")

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

		local found=0
		for addr in "${addresses_list[@]}"; do
			if [ "$chosen" = "$addr" ]; then
				found=1
				sure=$(echo -e "$icon_check\n$icon_close Back" | display_menu 1 "$tr_menu_addresses_sure_prompt_1 ${chosen}$tr_menu_addresses_sure_prompt_2" "")
				if [ -z "$sure" ] || [[ "$sure" =~ ^"$icon_close Back" ]]; then continue; fi
				if [[ "$sure" =~ ^"$icon_check" ]]; then
					nmcli connection modify uuid "$connection_uuid" -ipv${ipv}.addresses "$chosen"
					if [ ${#addresses_list[@]} -eq 1 ]; then
						nmcli connection modify uuid "$connection_uuid" ipv${ipv}.gateway ''
						nmcli connection modify uuid "$connection_uuid" ipv${ipv}.method auto
					fi
				fi
				break
			fi
		done

		if [ "$found" -eq 0 ]; then
			nmcli connection modify uuid "$connection_uuid" +ipv${ipv}.addresses "$chosen"
			nmcli connection modify uuid "$connection_uuid" ipv${ipv}.method manual
		fi
	done
}

menu_ip_config() {
	local chosen_connection_name="$1"
	local connection_uuid="$2"
	local ipv="$3"
	local autoip_state autodns_state message new_gateway chosen

	while true; do
		autoip_state="$([ "$(nmcli --get-values ipv${ipv}.method connection show "$connection_uuid")" = "auto" ] && echo "$icon_on" || echo "$icon_off")"

		local current_gateway=$(nmcli --get-values ipv${ipv}.gateway connection show "$connection_uuid")
		local current_addresses=$(nmcli --get-values ipv${ipv}.addresses connection show "$connection_uuid" | sed 's/,/\n/g')

		local options=""
		options+="$icon_auto_ip  $tr_autoip_message  $autoip_state\n"

		if [ "$autoip_state" = "$icon_on" ]; then
			autodns_state="$([ "$(nmcli --get-values ipv${ipv}.ignore-auto-dns connection show "$connection_uuid")" = "no" ] && echo "$icon_on" || echo "$icon_off")"
			options+="$icon_auto_dns  $tr_autodns_message  $autodns_state\n"
		else
			options+="$icon_address  $tr_address_message: ${current_addresses:-N/A}\n"
			options+="$icon_gateway  $tr_gateway_message ${current_gateway:-N/A}\n"
			options+="$icon_gateway  $tr_gateway_message ${current_gateway:-N/A}\n"
		fi
		options+="$icon_ipv4_dns  DNS Configuration\n"
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$chosen_connection_name (IPv$ipv)" "")

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

		case "$chosen" in
			*"DNS Configuration"*)
				menu_dns "$connection_uuid" "$ipv"
				;;
			*"$tr_autoip_message"*)
				if [ "$autoip_state" = "$icon_on" ]; then

                    local ex_ip="192.168.1.10/24"
                    local ex_gw="192.168.1.1"
                    if [ "$ipv" = "6" ]; then
                        ex_ip="2001:db8::1/64"
                        ex_gw="fe80::1"
                    fi

					local new_addrs=$(echo "" | display_menu 5 "Enter IP Address (e.g. $ex_ip)" "")
					if [ -z "$new_addrs" ]; then continue; fi

					local new_gw=$(echo "" | display_menu 5 "Enter Gateway (Optional, e.g. $ex_gw)" "")

					local new_dns=$(echo "" | display_menu 5 "Enter DNS Server (Optional, e.g. 8.8.8.8)" "")

					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.method manual ipv${ipv}.addresses "$new_addrs"

                    if [ -n "$new_gw" ]; then
                        nmcli connection modify uuid "$connection_uuid" ipv${ipv}.gateway "$new_gw"
                    fi

                    if [ -n "$new_dns" ]; then
                        nmcli connection modify uuid "$connection_uuid" ipv${ipv}.dns "$new_dns"
                        nmcli connection modify uuid "$connection_uuid" ipv${ipv}.ignore-auto-dns yes
                    fi
				else
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.method auto
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.gateway ''
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.addresses ''
				fi
				;;
			*"$tr_autodns_message"*)
				if [ "$autodns_state" = "$icon_on" ]; then

					local new_dns=$(echo "" | display_menu 5 "Enter DNS Server (e.g. 8.8.8.8)" "")
					if [ -n "$new_dns" ]; then

						nmcli connection modify uuid "$connection_uuid" ipv${ipv}.dns "$new_dns"
						nmcli connection modify uuid "$connection_uuid" ipv${ipv}.ignore-auto-dns yes
					else

						: 
					fi
				else
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.ignore-auto-dns no
				fi
				;;
			*"$tr_address_message"*)
				menu_addresses "$connection_uuid" "$ipv"
				;;
			*"$tr_gateway_message"*)
				new_gateway=$(echo "$icon_close Back" | display_menu 1 "$tr_menu_ip_config_gateway_prompt" "")
				if [ -z "$new_gateway" ] || [[ "$new_gateway" =~ ^"$icon_close Back" ]]; then continue; fi
				nmcli connection modify uuid "$connection_uuid" ipv${ipv}.gateway "$new_gateway"
				;;
		esac
	done
}

menu_dns() {
	local connection_uuid="$1"
	local ipv="$2"
	local -a dns_list
	local sure chosen

	while true; do
		mapfile -t dns_list < <(nmcli --get-values ipv${ipv}.dns connection show "$connection_uuid" | sed 's/,/\n/g')
		local options=""

		if [ ${#dns_list[@]} -gt 0 ] && [ -n "${dns_list[0]}" ]; then
			options=$(printf "%s\n" "${dns_list[@]}")
			options+="\n"
		fi
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$tr_menu_dns_prompt" "")

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

		local found=0
		for dns_entry in "${dns_list[@]}"; do
			if [ "$chosen" = "$dns_entry" ]; then
				found=1
				sure=$(echo -e "$icon_check Remove\n$icon_close Back" | display_menu 1 "$tr_menu_dns_sure_prompt_1 ${chosen}$tr_menu_dns_sure_prompt_2" "")
				if [ -z "$sure" ] || [[ "$sure" =~ ^"$icon_close Back" ]]; then continue; fi
				if [[ "$sure" =~ ^"$icon_check" ]]; then
					nmcli connection modify uuid "$connection_uuid" -ipv${ipv}.dns "$chosen"
				fi
				break
			fi
			done

		if [ "$found" -eq 0 ]; then
			nmcli connection modify uuid "$connection_uuid" +ipv${ipv}.dns "$chosen"
		fi
	done
}

forget_connection() {
	local chosen_connection_name="$1"
	local connection_uuid="$2"
    local options="$icon_check $tr_forget_connection_confirm\n$icon_close Back"
	local sure=$(echo -e "$options" | display_menu 4 "$tr_forget_connection_sure_prompt_1 ${chosen_connection_name}$tr_forget_connection_sure_prompt_2" "")

	if [ -z "$sure" ] || [[ "$sure" =~ ^"$icon_close Back" ]]; then return 1; fi
	if [[ "$sure" =~ ^"$icon_check $tr_forget_connection_confirm" ]]; then
		nmcli connection delete uuid "$connection_uuid" && return 0
	fi
	return 1
}

rename_connection() {
	local connection_uuid="$1"
	local new_name=$(echo "" | display_menu 5 "$tr_rename_connection_prompt" "")

	if [ -z "$new_name" ]; then return 1; fi

	nmcli connection modify uuid "$connection_uuid" connection.id "$new_name"
	return $?
}

edit_connection_password() {
    local connection_uuid="$1"
    local connection_name="$2"

    local pass=$(ask_password "$connection_name")

    if [ -z "$pass" ]; then return 1; fi

    if nmcli connection modify uuid "$connection_uuid" wifi-sec.psk "$pass"; then
        send_notification "$tr_password_updated_summary" "$tr_password_updated_body '$connection_name'"
        return 0
    else
        send_notification "$tr_password_update_failed_summary" "$tr_password_update_failed_body '$connection_name'" "error"
        return 1
    fi
}

menu_connection() {
	local chosen_connection_name="$1"
	local connection_uuid="$2"
	local autoconnect_state chosen

    while true; do
		autoconnect_state="$([ "$(nmcli --get-values connection.autoconnect connection show "$connection_uuid")" = "yes" ] && echo "$icon_on" || echo "$icon_off")"

        local is_active=$(nmcli -t -f UUID connection show --active | grep -q "$connection_uuid" && echo "yes" || echo "no")

        local options="$icon_automatic  $tr_autoconnect_message  $autoconnect_state\n"

        if [ "$is_active" = "yes" ]; then
             options+="$icon_wifi_disconnected  $tr_disconnect_message\n"
        else
             options+="$icon_connect  $tr_connect_now_message\n"
        fi

		options+="$icon_ipv4_config  $tr_ipv4_config_message\n"
		options+="$icon_ipv6_config  $tr_ipv6_config_message\n"
		options+="$icon_trash  $tr_forget_message\n"
		options+="$icon_pen  $tr_rename_connection_message\n"
        options+="$icon_password  $tr_edit_password_message\n"

        if [ "$(nmcli -g connection.type connection show "$connection_uuid")" = "802-11-wireless" ]; then
             options+="$icon_qrcode  $tr_qrcode_message\n"
        fi
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$chosen_connection_name" "$icon_config")

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

		case "$chosen" in
			*"$tr_autoconnect_message"*)
				if [ "$autoconnect_state" = "$icon_on" ]; then
					nmcli connection modify uuid "$connection_uuid" autoconnect no
				else
					nmcli connection modify uuid "$connection_uuid" autoconnect yes
				fi
				;;
            "$icon_connect  $tr_connect_now_message")
                while true; do
                    show_loading_notification "$tr_connecting_to '$chosen_connection_name'$tr_please_wait"
                    output=$(nmcli connection up uuid "$connection_uuid" 2>&1)
                    if [ $? -eq 0 ]; then
                        kill_loading_notification
                        send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$chosen_connection_name'"
                        exit 0
                    else
                        kill_loading_notification

                        local choice=$(show_error_dialog "$output")
                        case "$choice" in
                            *"Try Again") continue ;;
                            *"Edit Password") 
                                edit_connection_password "$connection_uuid" "$chosen_connection_name"
                                continue 
                                ;;
                            *) 

                                send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$chosen_connection_name'" "error"
                                break
                                ;;
                        esac
                    fi
                done
                ;;
            "$icon_wifi_disconnected  $tr_disconnect_message")

                 show_loading_notification "Disconnecting..."
                 if nmcli connection down uuid "$connection_uuid"; then
                    kill_loading_notification
                    send_notification "Disconnected" "Disconnected from '$chosen_connection_name'"
                    return
                 else
                    kill_loading_notification
                    show_message "Failed to disconnect."
                 fi
                 ;;
			*"$tr_ipv4_config_message"*) menu_ip_config "$chosen_connection_name" "$connection_uuid" "4" ;;
			*"$tr_ipv6_config_message"*) menu_ip_config "$chosen_connection_name" "$connection_uuid" "6" ;;
			*"$tr_forget_message"*) forget_connection "$chosen_connection_name" "$connection_uuid" && return ;;
			*"$tr_rename_connection_message"*)
				if rename_connection "$connection_uuid"; then
					show_message "Connection renamed."
					chosen_connection_name=$(nmcli --get-values connection.id connection show "$connection_uuid")
				else
					show_message "Failed to rename connection."
				fi
				;;
            *"$tr_edit_password_message"*)
                edit_connection_password "$connection_uuid" "$chosen_connection_name"
                ;;
            *"$tr_qrcode_message"*)
                local ssid=$(nmcli -g 802-11-wireless.ssid connection show "$connection_uuid")
                local security=$(nmcli -g 802-11-wireless-security.key-mgmt connection show "$connection_uuid" | sed 's/wpa-psk/WPA/; s/None/nopass/')
                local password=$(nmcli -s -g 802-11-wireless-security.psk connection show "$connection_uuid")
                show_qrcode "$ssid" "$security" "$password"
                ;;
		esac
	done
}

menu_wireguard_connection(){
	local chosen_connection_name="$1"
	local connection_uuid="$2"
	local state autoconnect_state chosen

	while true; do
		state="$([ "$(nmcli --get-values GENERAL.STATE connection show "$connection_uuid")" = "activated" ] && echo "$icon_on" || echo "$icon_off")"
		autoconnect_state="$([ "$(nmcli --get-values connection.autoconnect connection show "$connection_uuid")" = "yes" ] && echo "$icon_on" || echo "$icon_off")"
		local options="$icon_plug  $tr_wireguard_enable_message  $state\n"
		options+="$icon_automatic  $tr_autoconnect_message  $autoconnect_state\n"
		options+="$icon_pen  $tr_rename_connection_message\n"
		options+="$icon_trash  $tr_forget_message\n"
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$chosen_connection_name" "")

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

		case "$chosen" in
			*"$tr_wireguard_enable_message"*)
				if [ "$state" = "$icon_on" ]; then
					nmcli connection down uuid "$connection_uuid"
				else
					local output
                    if output=$(nmcli connection up uuid "$connection_uuid" 2>&1); then

                        :
                    else

                        show_error_dialog "$output"
                    fi
				fi
				;;
			*"$tr_autoconnect_message"*)
				if [ "$autoconnect_state" = "$icon_on" ]; then
					nmcli connection modify uuid "$connection_uuid" autoconnect no
				else
					nmcli connection modify uuid "$connection_uuid" autoconnect yes
				fi
				;;
			*"$tr_rename_connection_message"*)
				if rename_connection "$connection_uuid"; then
					show_message "Connection renamed."
					chosen_connection_name=$(nmcli --get-values connection.id connection show "$connection_uuid")
				else
					show_message "Failed to rename connection."
				fi
				;;
			*"$tr_forget_message"*) forget_connection "$chosen_connection_name" "$connection_uuid" && return ;;
		esac
	done
}

menu_known_connections() {
	local connection_filter="$1"
	local icon_for_type
	local menu_type_function
    local profiles_list_raw chosen
    local prompt_to_use

	case "$connection_filter" in
		"wifi")
			icon_for_type="$icon_wireless"
			menu_type_function="menu_connection"

            local raw_wifi_list=$(nmcli -t -f UUID,NAME,TYPE connection show | grep ":802-11-wireless")
            profiles_list_raw=""
            while IFS=':' read -r uuid name type; do
                 local mode=$(nmcli -g 802-11-wireless.mode connection show "$uuid" 2>/dev/null)

                 if [ "$mode" != "ap" ]; then

                     profiles_list_raw+="${uuid};;;${icon_for_type}  ${name};;;${name}\n"
                 fi
            done <<< "$raw_wifi_list"

            profiles_list_raw="${profiles_list_raw%\\n}"

            prompt_to_use="$tr_known_connections_message"
			;;
		"wireguard")
			icon_for_type="$icon_wireguard"
			menu_type_function="menu_wireguard_connection"

            profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_for_type" '$1 == "wireguard" {print $2 ";;;" icon "  " $3 ";;;" $3}')
            prompt_to_use="$tr_vpn_menu_prompt"
			;;
		"ethernet")
			icon_for_type="$icon_ethernet"
			menu_type_function="menu_connection"

            profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_for_type" '$1 ~ /^(ethernet|802-3-ethernet).*/ {print $2 ";;;" icon "  " $3 ";;;" $3}')
            prompt_to_use="$tr_manage_wired_connections"
			;;
		*)
			icon_for_type="$icon_saved"
			menu_type_function="menu_connection"

            local all_conns=$(nmcli -t -f UUID,TYPE,NAME connection show)
            profiles_list_raw=""

            while IFS=':' read -r uuid type name; do
                local show_item="yes"
                local icon="$icon_saved"

                if [[ "$type" == "wifi" || "$type" == "802-11-wireless" ]]; then
                     local mode=$(nmcli -g 802-11-wireless.mode connection show "$uuid" 2>/dev/null)
                     if [ "$mode" = "ap" ]; then
                        show_item="no"
                     fi
                     icon="$icon_wireless"
                elif [[ "$type" == "ethernet" || "$type" == "802-3-ethernet" ]]; then
                    icon="$icon_ethernet"
                elif [[ "$type" == "vpn" || "$type" == "wireguard" ]]; then
                    icon="$icon_vpn_disconnect"
                elif [[ "$type" == "bluetooth" ]]; then
                    icon="$icon_bluetooth"
                elif [[ "$type" == "loopback" ]]; then
                    show_item="no"
                else
                    icon="$icon_config" 
                fi

                if [ "$show_item" = "yes" ]; then

                     profiles_list_raw+="${uuid};;;${icon}  ${name} ($type);;;${name}\n"
                fi
            done <<< "$all_conns"

            profiles_list_raw="${profiles_list_raw%\\n}"
            prompt_to_use="$tr_saved_connections_menu_prompt"
			;;
	esac

    if [ -n "$profiles_list_raw" ]; then
        mapfile -t profiles_list < <(printf "%b" "$profiles_list_raw")
    else
        profiles_list=()
    fi

    if [ "${#profiles_list[@]}" -eq 0 ]; then
        display_info_message "$tr_no_saved_connections" "$prompt_to_use"
        return
    fi

    if [ -z "${profiles_list[0]}" ]; then
         return
    fi

	while true; do

		local options=$(for i in "${profiles_list[@]}"; do echo "$i" | awk -F';;;' '{print $2}'; done)
		options+="\n$icon_close Back"

		chosen_index=$(echo -e "$options" | display_menu 1 "$prompt_to_use" "$icon_saved" "-format i")

		if [ -z "$chosen_index" ]; then
            return
        fi

        if [ "$chosen_index" -eq "${#profiles_list[@]}" ]; then
             return
        fi

        local selected_item="${profiles_list[$chosen_index]}"

        local conn_uuid=$(echo "$selected_item" | awk -F';;;' '{print $1}')
        local conn_real_name=$(echo "$selected_item" | awk -F';;;' '{print $3}')

        eval "$menu_type_function \"$(sed 's/"/\\"/g' <<< "$conn_real_name")\" \"$conn_uuid\""

	done
}

menu_connect_wired_connection() {
    local profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_ethernet" '$1 ~ /^(ethernet|802-3-ethernet).*/ {print $2 "\\0" icon "  " " " $3}')
    mapfile -t profiles_list < <(echo "$profiles_list_raw")

    if [ "${#profiles_list[@]}" -eq 0 ] || ([ "${#profiles_list[@]}" -eq 1 ] && [ -z "${profiles_list[0]}" ]); then
        display_info_message "No saved wired connections to connect to." "$tr_connect_wired_connection"
        return
    fi

    local options=$(for i in "${profiles_list[@]}"; do echo -e "$i" | cut --delimiter $'\0' --fields 2; done)
    options+="\n$icon_close Back"

    local chosen=$(echo -e "$options" | display_menu 1 "$tr_connect_wired_connection" "$icon_search")

    if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
        return
    fi

    local conn_uuid_to_connect=""
    local conn_name_to_connect=""

    for i in "${profiles_list[@]}"; do
        if [ "$chosen" = "$(echo -e "$i" | cut --delimiter $'\0' --fields 2)" ]; then
            conn_uuid_to_connect=$(echo -e "$i" | cut --delimiter $'\0' --fields 1)
            conn_name_to_connect=$(echo -e "$i" | cut --delimiter $'\0' --fields 2 | sed -E 's/^(󰈀) //')
            break
        fi
    done

    if [ -n "$conn_uuid_to_connect" ]; then
        show_loading_notification "$tr_connecting_to '$conn_name_to_connect'..."
        if nmcli connection up uuid "$conn_uuid_to_connect"; then
            kill_loading_notification
            send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$conn_name_to_connect'"
            exit 0
        else
            kill_loading_notification
            send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$conn_name_to_connect'" "error"
        fi
    else
        show_message "Could not find connection profile for $conn_name_to_connect." "$tr_connect_wired_connection"
    fi
}

# =============================================================================
#                             WIRED MENU CONTROLLER
# =============================================================================

menu_wired() {
    while true; do
        local active_wired_conn=$(nmcli -t -f TYPE,DEVICE connection show --active | grep -vE "(wireless|vpn|wireguard)" | head -n 1)
        local status_line=""
        if [ -n "$active_wired_conn" ]; then
            local active_device=$(echo "$active_wired_conn" | cut -d':' -f2)
            status_line="$icon_ethernet $tr_status_message $tr_status_connected ($active_device)"
        else
            status_line="$icon_ethernet $tr_status_message $tr_status_disconnected"
        fi

        local options="$status_line\n"
        options+="$icon_connect_wired Connect to Wired Connection\n"
        options+="$icon_config $tr_manage_wired_connections\n"
        options+="$icon_close Back"

        local choice=$(echo -e "$options" | display_menu 1 "$tr_wired_menu_prompt" "")

        if [ -z "$choice" ] || [[ "$choice" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$choice" in
            *"Connect to Wired Connection"*)
                menu_connect_wired_connection
                ;;
            *"$tr_manage_wired_connections"*)
                menu_known_connections "ethernet"
                ;;
            *"$tr_status_message"*)
                ;;
            *)
                show_message "Invalid option selected: $choice" "$tr_wired_menu_prompt"
                ;;
        esac
    done
}

show_active_connection_details() {
    local device="$1"
    local details_raw=$(nmcli --colors no device show "$device")

    local prompt_text="$icon_active_details Active Connection Details: $icon_search"
    echo -e "${details_raw}\n${icon_close} Back" | display_menu 1 "$prompt_text" ""
}

status_menu() {
    local options="$icon_active_details Active Connection Details\n$icon_devices All Device Status\n$icon_close Back"

    local choice=$(echo -e "$options" | display_menu 1 "$tr_status_menu_prompt" "")

    if [ -z "$choice" ] || [[ "$choice" =~ ^"$icon_close Back" ]]; then
        return
    fi

    case "$choice" in
        *"Active Connection Details")
            local active_conn_device=$(nmcli -t -f DEVICE connection show --active | head -n 1)
            if [ -z "$active_conn_device" ]; then
                display_info_message "$tr_no_active_connection"
            else
                show_active_connection_details "$active_conn_device"
            fi
            ;;
        *"All Device Status")
            local device_status=$(nmcli device status)

            echo -e "$device_status\n$icon_close Back" | display_menu 1 "$tr_status_menu_prompt" ""
            ;;
    esac
}

toggle_airplane_mode() {
    local wifi_state=$(nmcli radio wifi)
    local wwan_state=$(nmcli radio wwan 2>/dev/null || echo "disabled")

    if [ "$wifi_state" = "enabled" ] || [ "$wwan_state" = "enabled" ]; then

        nmcli radio wifi off
        nmcli radio wwan off 2>/dev/null
        display_info_message "$tr_airplane_on" "$tr_airplane_mode_message" "$icon_airplane_on"
    else

        nmcli radio wifi on
        nmcli radio wwan on 2>/dev/null
        display_info_message "$tr_airplane_off" "$tr_airplane_mode_message" "$icon_airplane_off"
    fi
}

show_qrcode() {
    local ssid="$1"
    local security="$2"
    local password="$3"

    if ! command -v qrencode &> /dev/null; then
        show_message "$tr_qrcode_error" "$tr_qrcode_message"
        return
    fi

    if [ -z "$password" ]; then
        show_message "$tr_qrcode_no_password" "$tr_qrcode_message"
        return
    fi

    local qr_string="WIFI:T:${security};S:${ssid};P:${password};;"
    local qr_file="/tmp/hyprltm-net-qr-${ssid}.png"

    show_loading_notification "$tr_qrcode_generating"
    qrencode -o "$qr_file" -s 10 -m 2 "$qr_string"
    kill_loading_notification

    local rofi_override="
        window { width: 500px; }
        listview { lines: 1; scrollbar: false; }
        element { orientation: vertical; padding: 20px; children: [ element-icon, element-text ]; }
        element-icon { enabled: true; size: 300px; horizontal-align: 0.5; }
        element-text { horizontal-align: 0.5; }
        entry { enabled: false; } 
        inputbar { enabled: false; }
    "

    echo -e "Scan to Connect\0icon\x1f${qr_file}" | \
    rofi -dmenu -i -show-icons -p "$tr_qrcode_message" -theme "$ROFI_NETWORK_MANAGER_THEME" \
         -theme-str "$rofi_override" >/dev/null

    rm -f "$qr_file" 2>/dev/null
}

get_wifi_password() {
    local ssid="$1"
    local uuid=$(nmcli -t -f NAME,UUID connection show | grep "^${ssid}:" | cut -d':' -f2)
    if [ -n "$uuid" ]; then
        nmcli -s -g 802-11-wireless-security.psk connection show "$uuid" 2>/dev/null
    fi
}

create_hotspot() {

    if ! command -v dnsmasq &> /dev/null; then
        show_message "❌ Missing dependency: 'dnsmasq'\nRequired to assign IP addresses (DHCP) to connected devices.\nPlease install it: sudo pacman -S dnsmasq (or equivalent)" "$tr_hotspot_message"
        return
    fi

    local active_connection=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ":802-11-wireless:${interface_to_use}")

    if [ -n "$active_connection" ]; then

        if ! show_warning_dialog "⚠️ Wi-Fi Disconnect Required" "Starting a Hotspot will disconnect you from the current Wi-Fi network.\nYour card cannot do both simultaneously."; then
            return
        fi

        show_loading_notification "Disconnecting Wi-Fi..."
        nmcli device disconnect "$interface_to_use" &> /dev/null
        kill_loading_notification
    fi

    local ssid=$(echo "" | display_menu 5 "$tr_hotspot_ssid_prompt" "")
    if [ -z "$ssid" ]; then
        return
    fi

    local password=$(echo "" | display_menu 3 "$tr_hotspot_password_prompt" "")
    if [ -z "$password" ] || [ ${#password} -lt 8 ]; then
        show_message "Password must be at least 8 characters." "$tr_hotspot_message"
        return
    fi

    show_loading_notification "$tr_hotspot_creating"

    nmcli connection delete id "$ssid" &> /dev/null

    if nmcli connection add type wifi ifname "$interface_to_use" \
        con-name "$ssid" \
        ssid "$ssid" \
        wifi.mode ap \
        wifi.band bg \
        wifi-sec.key-mgmt wpa-psk \
        wifi-sec.psk "$password" \
        ipv4.method shared \
        ipv6.method shared \
        connection.autoconnect no &> /dev/null; then

        if nmcli connection up id "$ssid" &> /dev/null; then
            kill_loading_notification
            kill_loading_notification
            show_success_dialog "$tr_hotspot_message" "$tr_hotspot_success\nSSID: $ssid\nPassword: $password"

            send_notification "Hotspot Created" "$tr_hotspot_success\nSSID: $ssid"
        else
            kill_loading_notification
            show_error_dialog "$tr_hotspot_error (Failed to activate)"

            nmcli connection delete id "$ssid" &> /dev/null
        fi
    else
        kill_loading_notification
        show_error_dialog "$tr_hotspot_error (Failed to create profile)"
    fi
}

import_vpn() {
    local vpn_file_path=$(echo "" | display_menu 5 "$tr_import_vpn_prompt" "")

    if [ -z "$vpn_file_path" ]; then
        return
    fi

    if [ ! -f "$vpn_file_path" ]; then
        send_notification "$tr_notice_import_error_summary" "$tr_notice_file_not_found_body" "error"
        return
    fi

    local vpn_type=""
    case "$vpn_file_path" in
        *.conf) vpn_type="wireguard" ;;
        *.ovpn) vpn_type="openvpn" ;;
        *)
            send_notification "$tr_notice_import_error_summary" "$tr_notice_unknown_vpn_type_body" "error"
            return
            ;;
    esac

    local import_output
    import_output=$(nmcli connection import type "$vpn_type" file "$vpn_file_path" 2>&1)

    if [ $? -eq 0 ]; then

        local uuid=$(echo "$import_output" | sed -n 's/.*(\(.*\)) successfully added.*/\1/p')

        if [ -n "$uuid" ]; then
            nmcli connection modify "$uuid" connection.autoconnect no
        fi

        send_notification "$tr_notice_import_success_summary" "$tr_notice_import_success_body"
    else
        send_notification "$tr_notice_import_error_summary" "$tr_notice_import_error_body" "error"
    fi
}

toggle_vpn_connection() {
    local uuid="$1"
    local name="$2"
    local state="$3"

    if [ "$state" = "activated" ]; then
        show_loading_notification "$tr_disconnecting_from '$name'$tr_please_wait"
        if nmcli connection down uuid "$uuid"; then
            kill_loading_notification
            send_notification "$tr_notice_disconnected_summary" "$tr_notice_disconnected_body '$name'"
            exit 0
        else
            kill_loading_notification
            send_notification "$tr_notice_error_summary" "$tr_notice_error_disconnect_body '$name'" "error"
        fi
    else
        while true; do
            show_loading_notification "$tr_connecting_to '$name'$tr_please_wait"
            output=$(nmcli connection up uuid "$uuid" 2>&1)
            if [ $? -eq 0 ]; then
                kill_loading_notification
                send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$name'"
                exit 0
            else
                kill_loading_notification

                local choice=$(show_error_dialog "$output")
                case "$choice" in
                    *"Try Again") continue ;;
                    *"Edit Password") 
                        edit_connection_password "$uuid" "$name"
                        continue 
                        ;;
                    *) 
                        send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$name'" "error"
                        break 
                        ;;
                esac
            fi
        done
    fi
}

menu_available_vpns() {
    while true; do
        mapfile -t vpn_list < <(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' '$1 == "vpn" || $1 == "wireguard" {print $2 "\\0" $3}')

        if [ "${#vpn_list[@]}" -eq 0 ] || [ -z "${vpn_list[0]}" ]; then
            display_info_message "$tr_no_configured_vpns" "$tr_available_vpn_profiles_message"
            return
        fi

        local options=""
        for i in "${vpn_list[@]}"; do
            local uuid=$(echo -e "$i" | awk 'BEGIN{FS="\x00"}{print$1}')
            local name=$(echo -e "$i" | awk 'BEGIN{FS="\x00"}{print$2}')
            local state=$(nmcli --get-values GENERAL.STATE connection show uuid "$uuid")
            local state_icon="$([ "$state" = "activated" ] && echo "$icon_on" || echo "$icon_off")"
            options+="$state_icon  $name\n"
        done
        options+="$icon_close Back"

        local chosen=$(echo -e "$options" | display_menu 1 "$tr_available_vpn_profiles_message" "$icon_search")

        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

        local chosen_name=$(echo "$chosen" | sed -E 's/^(|)  //')
        for i in "${vpn_list[@]}"; do
            local uuid=$(echo -e "$i" | awk 'BEGIN{FS="\x00"}{print$1}')
            local name=$(echo -e "$i" | awk 'BEGIN{FS="\x00"}{print$2}')
            if [ "$name" = "$chosen_name" ]; then
                local state=$(nmcli --get-values GENERAL.STATE connection show uuid "$uuid")
                toggle_vpn_connection "$uuid" "$name" "$state"
                break
            fi
        done
    done
}

vpn_menu() {
    while true; do
        local options="$icon_vpn_disconnect  $tr_available_vpn_profiles_message\n"
        options+="$icon_import  $tr_import_vpn_message\n"
        options+="$icon_close Back"

        local choice=$(echo -e "$options" | display_menu 1 "$tr_vpn_menu_prompt" "")

        if [ -z "$choice" ] || [[ "$choice" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$choice" in
            *"$tr_available_vpn_profiles_message"*)
                menu_available_vpns
                ;;
            *"$tr_import_vpn_message"*)
                import_vpn
                ;;
        esac
    done
}

main_menu() {

    if ! is_notification_service_running; then
        show_warning_dialog "⚠️ No Notification Service Found" "You can continue, but you won't receive desktop notifications."
    fi

    local options="$icon_wifi_full  Wi-Fi\n"
    options+="$icon_ethernet  Wired\n"
    options+="$icon_vpn_disconnect  VPN\n"
    options+="$icon_bookmark_saved  Saved Connections\n"
    options+="$icon_status_chart  Status\n"
    options+="$icon_airplane  $tr_airplane_mode_message\n"
    options+="$icon_close Exit"

    while true; do
        local choice=$(echo -e "$options" | display_menu 1 "$tr_main_menu_prompt" "")

        if [ -z "$choice" ]; then

            exit 0
        fi

        case "$choice" in
            "$icon_close Exit") exit 0 ;;
            *"Wi-Fi")
                menu_wifi
                ;;
            *"Wired")
                menu_wired
                ;;
            *"VPN")
                vpn_menu
                ;;
            *"Saved Connections")
                menu_known_connections "all"
                ;;
            *"Status")
                status_menu
                ;;
            *"$tr_airplane_mode_message")
                toggle_airplane_mode
                ;;
        esac
    done
}

main_menu
