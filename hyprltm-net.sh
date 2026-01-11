#!/usr/bin/env bash
#    __  __                 __   ________  ___       _   __    __ 
#   / / / /_  ______  _____/ /  /_  __/  |/  /      / | / /___/ /_
#  / /_/ / / / / __ \/ ___/ /    / / / /|_/ /_____ /  |/ / _  / __/
# / __  / /_/ / /_/ / /  / /___ / / / /  / /_____ / /|  /  __/ /_  
#/_/ /_/\__, / .___/_/  /_____//_/ /_/  /_/      /_/ |_/\___/\__/  
#      /____/_/                                                   
#

# Copyright © 2025 Djalel Oukid (sniper1720)


# --- Dependencies Check ---
if ! command -v rofi &> /dev/null; then
    echo "Error: rofi is not installed. Please install it to use this script." >&2
    exit 1
fi
if ! command -v nmcli &> /dev/null; then
    echo "Error: nmcli is not installed. Please install NetworkManager and nmcli." >&2
    exit 1
fi

# --- Rofi Theme Arguments ---
# Use a dedicated Rofi theme file for the network manager script.
ROFI_NETWORK_MANAGER_THEME="$HOME/.config/rofi/themes/hyprltm-net.rasi"

# --- Icon Variables (Nerd Fonts - Minimalist & Beautiful) ---
# --- Icons: General UI ---
icon_search="${icon_search:-""}"
icon_close="${icon_close:-""}"
icon_check="${icon_check:-""}"
icon_on="${icon_on:-""}"
icon_off="${icon_off:-""}"
icon_info="${icon_info:-"󰖐"}"
icon_refresh="${icon_refresh:-"󰑐"}"
icon_config="${icon_config:-""}"

# --- Icons: Network Types ---
icon_network="${icon_network:-"󱂇"}"
icon_wifi_prompt="${icon_wifi_prompt:-"󱚾"}"
icon_ethernet="${icon_ethernet:-"󰈀"}"
icon_vpn="${icon_vpn:-"󰖃"}"
icon_wireguard="${icon_wireguard:-"󰖆"}"
icon_hotspot="${icon_hotspot:-"󱄙"}"
icon_airplane="${icon_airplane:-"󰀝"}"

# --- Icons: Wi-Fi Signal ---
icon_wifi_full="${icon_wifi_full:-"󰤨"}"
icon_wifi_good="${icon_wifi_good:-"󰤥"}"
icon_wifi_medium="${icon_wifi_medium:-"󰤢"}"
icon_wifi_low="${icon_wifi_low:-"󰤯"}"
icon_wifi_disconnected="${icon_wifi_disconnected:-"󰤫"}"
icon_wifi_enable="${icon_wifi_enable:-"󰖩"}"
icon_wifi_disable="${icon_wifi_disable:-"󰖪"}"

# --- Icons: Security & Status ---
icon_wifi_secure="${icon_wifi_secure:-""}"
icon_wifi_open="${icon_wifi_open:-"󰤠"}"
icon_unlock="${icon_unlock:-""}"
icon_password="${icon_password:-""}"
icon_eye="${icon_eye:-"󰛐"}"
icon_eye_closed="${icon_eye_closed:-"󰛑"}"
icon_bookmark_saved="${icon_bookmark_saved:-"󰢭"}"
icon_saved="${icon_saved:-"󰋋"}"

# --- Icons: Menus & Actions ---
icon_connect="${icon_connect:-"󰚫"}"
icon_disconnect="${icon_disconnect:-"qa"}"
icon_vpn_disconnect="${icon_vpn_disconnect:-"󰖂"}"
icon_trash="${icon_trash:-""}"
icon_pen="${icon_pen:-"󰑕"}"
icon_import="${icon_import:-"󰋺"}"
icon_qrcode="${icon_qrcode:-"󰐲"}"

# --- Icons: Details & Config ---
icon_active_details="${icon_active_details:-"󰋼"}"
icon_status_chart="${icon_status_chart:-"󱖫"}"
icon_interface="${icon_interface:-"󰛨"}"
icon_devices="${icon_devices:-"󰋽"}"
icon_chip="${icon_chip:-"󰢮"}"
icon_ipv4_config="${icon_ipv4_config:-"󰒓"}"
icon_ipv4_dns="${icon_ipv4_dns:-"󰒍"}"
icon_ipv6_config="${icon_ipv6_config:-"󰒓"}" # Reuse
icon_ipv6_dns="${icon_ipv6_dns:-"󰒍"}"    # Reuse
icon_auto_ip="${icon_auto_ip:-"󰑘"}"
icon_auto_dns="${icon_auto_dns:-"󰒍"}"
icon_address="${icon_address:-"󰒓"}"
icon_gateway="${icon_gateway:-"󰞡"}"
icon_plug="${icon_plug:-"󱘖"}"
icon_wireless="${icon_wireless:-"󰑩"}"
icon_automatic="${icon_automatic:-"󰑘"}"

# --- Icons: Miscellaneous ---
icon_hidden_network="${icon_hidden_network:-"󰲊"}"
icon_connect_wired="${icon_connect_wired:-"󱂇"}"
icon_wired_status="${icon_wired_status:-"󰈁"}"

# --- Translatable / Customizable Messages ---
tr_checking_wifi_status='Checking Wi-Fi status... Please be patient.'
tr_scanning_networks='Scanning networks... Please be patient.'
tr_connecting_to='Connecting... Please be patient.'
tr_disconnecting_from='Disconnecting... Please be patient.'
tr_submenu_message='More options'
tr_disable_message='Disable Wi-Fi'
tr_enable_message='Enable Wi-Fi'
tr_interface_message='Interface:'
tr_known_connections_message='Known connections' # FIX: Removed colon
tr_available_networks_message='Available Networks'
tr_available_vpn_profiles_message='Available VPN Profiles'
tr_autoconnect_message='Autoconnect'
tr_ipv4_config_message='IPv4 Configuration'
tr_ipv6_config_message='IPv6 Configuration'
tr_dns4_message='DNS IPv4'
tr_dns6_message='DNS IPv6'
tr_connection_details_message='Connection Details' # New Header
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
tr_refresh_scan_message='Refresh Scan' # New message for refresh option
tr_no_known_wifi_connections='No known Wi-Fi connections.' # New message
tr_no_configured_vpns='No VPN connections configured.' # New message
tr_no_active_vpns='No active VPN connections.' # New message
tr_no_saved_connections='No saved connections found.' # New message
tr_no_active_connection='No active connection.' # New message
tr_no_ethernet_device='No Ethernet device found.' # New message
tr_no_wifi_networks_found='No Wi-Fi networks found.' # New message for empty scan
tr_wired_status_message='Wired Status' # New message for wired status option
tr_manage_wired_profile='Manage Active Wired Profile' # New message for wired profile management
tr_connect_wired_connection='Connect to Wired Connection:' # Refined prompt
tr_manage_wired_connections='Manage Wired Connections' # New message for wired connections management
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

# Airplane Mode
tr_airplane_mode_message='Airplane Mode'
tr_airplane_on='Airplane Mode Enabled'
tr_airplane_off='Airplane Mode Disabled'

# QR Code
tr_edit_password_message='Edit Password' # New translation
tr_password_prompt='Enter password for'
tr_password_updated='Password Updated'
tr_password_update_failed='Failed to update password'
tr_connection_failed_retry='Connection failed. Update password?'
tr_qrcode_message='Share via QR Code'
tr_qrcode_generating='Generating QR Code...'
tr_qrcode_error='Could not generate QR code. Is qrencode installed?'
tr_qrcode_no_password='Cannot share network without saved password.'

# Hotspot
tr_hotspot_message='Create Hotspot'
tr_hotspot_ssid_prompt='Enter Hotspot SSID:'
tr_hotspot_password_prompt='Enter Hotspot Password (min 8 chars):'
tr_hotspot_creating='Creating Hotspot...'
tr_hotspot_success='Hotspot created successfully!'
tr_hotspot_error='Failed to create hotspot.'
tr_notice_unknown_vpn_type_body='Unknown VPN file type. Use .conf or .ovpn.'

# Main menu prompt now includes network and search icons
tr_main_menu_prompt="$icon_network Network Manager: $icon_search"
tr_wifi_menu_prompt="$icon_wifi_prompt Wi-Fi: $icon_search"
tr_wired_menu_prompt="$icon_ethernet Wired: $icon_search" # NEW: Wired sub-menu prompt
tr_vpn_menu_prompt="$icon_vpn_disconnect VPN: $icon_search" # NEW: VPN sub-menu prompt
tr_saved_connections_menu_prompt="$icon_bookmark_saved Saved Connections: $icon_search" # NEW: Saved Connections sub-menu prompt
tr_status_menu_prompt="$icon_status_chart Status: $icon_search" # NEW: Status sub-menu prompt

tr_select_interface_prompt='Select Interface:'
tr_ask_password_prompt='Enter password:' # Refined prompt
tr_menu_dns_prompt='Enter DNS (e.g., 8.8.8.8):' # Refined prompt
tr_menu_dns_sure_prompt_1='Remove DNS '
tr_menu_dns_sure_prompt_2='?'
tr_menu_ip_config_addresses_prompt='Enter address (e.g., 192.168.1.10/24):' # Refined prompt
tr_menu_ip_config_gateway_prompt='Enter gateway (e.g., 192.168.1.1):' # Refined prompt
tr_menu_addresses_prompt='Type or select address (e.g., 192.168.1.10/24):' # Refined prompt
tr_menu_addresses_sure_prompt_1='Remove address '
tr_menu_addresses_sure_prompt_2='?'
tr_forget_connection_sure_prompt_1='Forget '
tr_forget_connection_sure_prompt_2='?'
tr_forget_connection_confirm='Yes, forget' # New confirmation text
tr_rename_connection_prompt='Enter new name for connection:' # Refined prompt
tr_connect_hidden_prompt='Enter hidden network name:' # Refined prompt

tr_notice_connected_summary='Connected'
tr_notice_disconnected_summary='Disconnected'
tr_notice_error_summary='Connection Error'
tr_notice_connected_body='Successfully connected to'
tr_notice_disconnected_body='Successfully disconnected from'
tr_notice_error_body='Failed to connect to'
tr_notice_error_disconnect_body='Failed to disconnect from'

# NEW: Messages for password input actions
tr_show_password_message='Show Password'
tr_hide_password_message='Hide Password'
tr_confirm_password_message='Confirm Password'
tr_edit_password_message='Edit Password'
tr_edit_password_prompt='Enter new password:'


# --- Global Variables ---
program_name="$(basename "$0")"
LOADING_ROFI_PID=""
mapfile -t interfaces < <(nmcli --colors no -t -f TYPE,DEVICE device status | awk -F ':' '$1 == "wifi" {print $2}')
if [ -z "${interfaces[0]}" ]; then
	echo "$program_name: No Wi-Fi interfaces detected." >&2
	exit 2
fi
interface_to_use="${interfaces[0]}"

# --- Helper Functions ---

# Function to display a menu (form 1: selection, 2: text input with list, 3: password input, 4: message box, 5: text input no list)
# Now accepts optional extra flags to pass to rofi.
display_menu() {
	local form="$1"
	local prompt_text="$2"
	local prompt_icon="${3:-}" # Optional: icon to prepend to prompt
    local extra_flags="${4:-}"   # Optional: extra flags for the rofi command
    local rofi_prompt rofi_flags options_list

	# If a prompt_icon is provided and the prompt_text doesn't already start with it, prepend it.
	if [ -n "$prompt_icon" ] && ! echo "$prompt_text" | grep -qE "^$prompt_icon"; then
		rofi_prompt="$prompt_icon $prompt_text"
	else
		rofi_prompt="$prompt_text"
	fi

	local result

	case $form in
		1) # Selection menu with a list of options passed via STDIN
            rofi_flags="-dmenu -i"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME")
            ;;
		2) # Generic text input menu with a list
            rofi_flags="-dmenu"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME")
            ;;
		3) # Password input menu (minimalist)
            rofi_flags="-dmenu -password"
            result=$(rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#listview { enabled: false; }')
            ;;
        4) # Message box menu (no input bar)
            rofi_flags="-dmenu -i"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#inputbar { enabled: false; }')
            ;;
        5) # Text input menu (no list view)
            rofi_flags="-dmenu"
            result=$(rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#listview { enabled: false; }')
            ;;
	esac
	echo "$result"
}


# --- Rofi-based Notification System ---

# Shows a non-blocking "loading" Rofi window and stores its PID.
show_loading_notification() {
    local message="$1"
    # Use dmenu mode to get the themed window, but completely override the
    # mainbox layout to show only a single, centered textbox.
    echo "" | rofi -dmenu -p "" \
        -theme "$ROFI_NETWORK_MANAGER_THEME" \
        -theme-str 'mainbox { children: [textbox]; }' \
        -theme-str 'textbox { str: "'"$message"'"; horizontal-align: 0.5; vertical-align: 0.5; background-color: transparent; text-color: @on-primary-fixed; padding: 8px 15px; }' &
    LOADING_ROFI_PID=$!
}

# Kills the loading notification Rofi window if it's running.
kill_loading_notification() {
    if [ -n "$LOADING_ROFI_PID" ] && ps -p "$LOADING_ROFI_PID" > /dev/null; then
        kill "$LOADING_ROFI_PID"
        LOADING_ROFI_PID=""
    fi
}

# Shows a final, blocking Rofi message for results (Success, Error, etc.).
# Optionally sends a system notification if notify-send is available.
send_notification() {
    local summary="$1"
    local body="$2"
    
    # Try system notification first (non-blocking)
    if command -v notify-send &> /dev/null; then
        notify-send -a "HyprLTM-Net" -i "network-wireless" "$summary" "$body"
    else
        # Fallback to Rofi message
        show_message "$body" "$summary"
    fi
}


# Function to show a message (stays open until dismissed, with "OK" button)
# Now accepts an optional custom_prompt and a flag to include the "OK" button.
show_message() {
    local msg="$1"
    local custom_prompt="${2:-Info}" # Default to "Info" if no custom prompt is provided
    local include_ok="${3:-true}" # Default to true
    local options="$msg"

    if [ "$include_ok" = "true" ]; then
        options+="\n$icon_check OK"
    fi
    # Use form 4 to disable the input bar for these messages
    echo -e "$options" | display_menu 4 "$custom_prompt" ""
}

# Function to display an informational message with a "Back" button
# Now accepts an optional custom_prompt
display_info_message() {
    local msg="$1"
    local custom_prompt="${2:-Info}" # Default to "Info" if no custom prompt is provided
    local options="$msg\n$icon_close Back"
    # Use form 4 to disable the input bar for these messages
    local chosen=$(echo -e "$options" | display_menu 4 "$custom_prompt" "")
    if [[ "$chosen" =~ ^"$icon_close Back" ]]; then
        return
    fi
}

# Handles password input with a dynamic, interactive menu for showing, hiding, and editing.
ask_password() {
    local password_input
    local password_shown="false" # 'true' or 'false'

    # Step 1: Initial password prompt
    password_input=$(echo "" | display_menu 3 "$tr_ask_password_prompt" "")
    
    # If user cancels the initial prompt (presses Esc or enters nothing), return empty.
    if [ -z "$password_input" ]; then
        return 1
    fi

    # Step 2: Interactive action menu loop
    while true; do
        local options=""
        local password_display=""

        # Determine how to display the password
        if [ "$password_shown" = "true" ]; then
            password_display="$password_input"
            options+="$icon_eye_closed $tr_hide_password_message: $password_display\n"
        else
            # Create a bullet point string of the same length as the password
            password_display=$(printf '•%.0s' $(seq 1 ${#password_input}))
            options+="$icon_eye $tr_show_password_message: $password_display\n"
        fi

        # Add other actions
        options+="$icon_pen $tr_edit_password_message\n"
        options+="$icon_unlock $tr_confirm_password_message\n"
        options+="$icon_close Back"

        # Display the interactive menu
        local action_choice=$(echo -e "$options" | display_menu 1 "Password Actions" "")

        # Handle user's choice
        if [ -z "$action_choice" ] || [[ "$action_choice" =~ ^"$icon_close Back" ]]; then
            # User cancelled at action menu
            return 1
        fi

        case "$action_choice" in
            *"$tr_show_password_message"*|*"$tr_hide_password_message"*)
                # Toggle password visibility
                if [ "$password_shown" = "true" ]; then
                    password_shown="false"
                else
                    password_shown="true"
                fi
                # Loop continues, redrawing the menu
                ;;
            *"$tr_edit_password_message"*)
                # Ask for a new password, pre-filling the input with the current password.
                local new_password=$(echo "" | display_menu 2 "$tr_edit_password_prompt" "" "-filter \"$password_input\"")
                # Only update if the user entered something and didn't cancel
                if [ -n "$new_password" ]; then
                    password_input="$new_password"
                    password_shown="false" # Hide new password by default
                fi
                # Loop continues, redrawing the menu
                ;;
            *"$tr_confirm_password_message"*)
                # Return the confirmed password
                echo "$password_input"
                return
                ;;
        esac
    done
}


# Show details for the active connection
show_connection_details() {
    local active_ssid="$1"
    local device="$2"
    
    show_loading_notification "Gathering details..."
    
    # Get details using nmcli device show
    # We grep for specific fields
    local info=$(nmcli -t -f GENERAL,IP4,IP6 device show "$device")
    
    # Extract fields (hacky but effective for standard nmcli output)
    # MAC often contains colons, so we strip the field name "GENERAL.HWADDR:"
    local ipv4=$(echo "$info" | grep "IP4.ADDRESS\[1\]" | cut -d':' -f2)
    local gateway=$(echo "$info" | grep "IP4.GATEWAY" | cut -d':' -f2)
    local hwaddr=$(echo "$info" | grep "GENERAL.HWADDR" | sed 's/^GENERAL.HWADDR://')
    local state=$(echo "$info" | grep "GENERAL.STATE" | cut -d':' -f2)
    
    # Wifi specific details
    local wifi_info=$(nmcli -t -f IN-USE,SSID,MODE,CHAN,RATE,SIGNAL,BARS,SECURITY device wifi list | grep "^\*")
    # Format: *:SSID:Infra:Chan:Rate:Signal:Bars:Sec
    local chan=$(echo "$wifi_info" | cut -d':' -f4)
    local rate=$(echo "$wifi_info" | cut -d':' -f5)
    local signal=$(echo "$wifi_info" | cut -d':' -f6)
    local bars=$(echo "$wifi_info" | cut -d':' -f7)
    local freq=""
    
    # Determine frequency band roughly by channel
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

    display_info_message "$details" "$tr_connection_details_message"
}

# --- Dedicated Wi-Fi Scan Function ---
perform_wifi_scan() {
    show_loading_notification "$tr_scanning_networks"
    
    # Get list of known SSIDs, delimited by |
    # We use tr to replace newline with |
    local known_ssids=$(nmcli -t -f 802-11-wireless.ssid connection show | tr '\n' '|')
    # Add leading/trailing pipe for exact matching
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
        # 1. First Icon: Signal Strength (Always shown)
        wifi_signal_icon = icon_wifi_low;
        if ($2 > 75) wifi_signal_icon = icon_wifi_full;
        else if ($2 > 50) wifi_signal_icon = icon_wifi_good;
        else if ($2 > 25) wifi_signal_icon = icon_wifi_medium;

        ssid = $3;
        if (ssid == "") ssid = "<hidden>";
        
        # 2. Second Icon: Status (Priority: Active > Secure > Open/Known)
        # User Logic: 
        # - Active -> Checkmark
        # - Secure (Even if known) -> Lock
        # - Open -> Unlock
        
        status_icon = icon_unlock; # Default to Unlock (Open)

        if ($4 == "*") {
             status_icon = icon_check; # Active -> Check
        } else if ($1 ~ /^WPA/) {
             status_icon = icon_wifi_secure; # Secure -> Lock
        } 
        # Else remains Unlock (Open)
        
        # Layout: [Signal] [Status] SSID (Sig%)
        # Note: We purposely put two icons on the left as requested.
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

# --- Menu for Available Wi-Fi Networks ---
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
        options+="$icon_close Back" # Always at the bottom

        # Prompt for this menu is just the search icon
        chosen=$(echo -e "$options" | display_menu 1 "$tr_available_networks_message" "$icon_search")

        # Handle Esc or "Back" selection
        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # Go back to parent menu (menu_wifi)
        fi

        case "$chosen" in
            "$icon_refresh  $tr_refresh_scan_message")
                continue # Restart the while loop to re-run scan and redisplay menu
                ;;
            "$icon_wifi_disconnected  $tr_no_wifi_networks_found")
                # Do nothing if "No Wi-Fi networks found" is selected
                continue
                ;;
            *)
                # This block should only be reached when a network is explicitly chosen
                connect_wifi "$chosen"
                ;;
        esac
    done
}


# --- Main Wi-Fi menu (toggle, hidden, known, available networks) ---
menu_wifi() {
	local connection_state options chosen
	while true; do
        show_loading_notification "$tr_checking_wifi_status"
		connection_state=$(nmcli --colors no --get-values WIFI general)
        local active_connection_info=$(nmcli -t -f NAME,DEVICE connection show --active | grep -E "wlan|wifi" | head -n 1)
        kill_loading_notification

        local status_line=""
		if [ "$connection_state" = "disabled" ]; then
            status_line="$icon_wifi_disable $tr_status_message $tr_status_disabled"
			options="$icon_wifi_enable  $tr_enable_message\n"
		else
            if [ -n "$active_connection_info" ]; then
                local active_ssid=$(echo "$active_connection_info" | cut -d':' -f1)
                local active_device=$(echo "$active_connection_info" | cut -d':' -f2)
                status_line="$icon_wifi_full $tr_status_message $tr_status_connected_to '$active_ssid' ($active_device)"
            else
                status_line="$icon_wifi_disconnected $tr_status_message $tr_status_disconnected"
            fi
			options="$icon_wifi_disable  $tr_disable_message\n"
			${interfaces[1]:+options+="$icon_interface  $tr_interface_message ${interface_to_use}\n"}
            # Add "Available Networks" as a sub-menu
            options+="$icon_wireless  $tr_available_networks_message\n"
		fi
        
        local full_options="$status_line\n"
        full_options+="$options"
        full_options+="$icon_hotspot  $tr_hotspot_message\n" # NEW: Create Hotspot
        full_options+="$icon_bookmark_saved  $tr_known_connections_message\n" # FIX: Using icon_bookmark_saved
        full_options+="$icon_hidden_network  $tr_hidden_message\n" # FIX: Using icon_hidden_network
        full_options+="$icon_close Back" # Always at the bottom

		chosen=$(echo -e "$full_options" | display_menu 1 "$tr_wifi_menu_prompt" "") # Pass "" for prompt_icon

        # Handle Esc or "Back" selection
		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # Go back to parent menu (main_menu)
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
            *"$tr_hotspot_message"*) create_hotspot ;;
            *"$tr_status_message"*) 
                # Show details if connected
                if [ -n "$active_connection_info" ]; then
                    local active_ssid=$(echo "$active_connection_info" | cut -d':' -f1)
                    local active_device=$(echo "$active_connection_info" | cut -d':' -f2)
                    show_connection_details "$active_ssid" "$active_device"
                fi
                ;;
			*)
                show_message "Invalid option selected: $chosen"
                ;;
		esac
	done
}


select_interface() {
	local chosen_interface=$( (for (( i = 0; i < ${#interfaces[@]}; i++ )); do echo "$icon_interface  ${interfaces[$i]}" ; done; echo "$icon_close Back") | display_menu 1 "$tr_select_interface_prompt" "") # Pass "" for prompt_icon

	if [ -z "$chosen_interface" ]; then
		return
	elif [[ "$chosen" =~ ^"$icon_close Back" ]]; then
		return
	else
		interface_to_use="${chosen_interface:3}"
	fi
}

# Connect to a hidden Wi-Fi network
connect_hidden() {
	local wifi_name=$(echo "" | display_menu 5 "$tr_connect_hidden_prompt" "") # Pass "" for prompt_icon

	if [ -z "$wifi_name" ]; then
		return # User cancelled or pressed back
	fi

	local wifi_password=$(ask_password)

	if [ -z "$wifi_password" ]; then
		show_message "Connection cancelled. No password provided."
		return
	fi

	show_loading_notification "$tr_connecting_to"
	if nmcli --wait 15 device wifi connect "$wifi_name" hidden yes password "$wifi_password"; then
        kill_loading_notification
		send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$wifi_name'"
        exit 0
    else
        kill_loading_notification
		send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$wifi_name'"
    fi
}

# Connect to a visible Wi-Fi network
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

    # 1. Check if already connected
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

    # 2. Check if we have a saved connection (even if not active)
    local saved_uuid=""
    # Use standard fields (UUID, TYPE) that are guaranteed to exist
    local saved_list=$(nmcli -t -f UUID,TYPE connection show)
    
    while IFS=: read -r uuid type; do
        # Check against both known Wi-Fi type strings
        if [[ "$type" == "802-11-wireless" || "$type" == "wifi" ]]; then
            # Get the SSID for this connection specifically
            local ssid_check=$(nmcli -t -f 802-11-wireless.ssid connection show "$uuid" 2>/dev/null)
            # FIX: output is '802-11-wireless.ssid:SSID', we must strip the prefix
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
     
    # 3. New Connection: Ask for password if secure
    local connection_result
	if [ "$is_secure" = "yes" ]; then
		local wifi_password=$(ask_password)
		if [ -z "$wifi_password" ]; then
			show_message "Connection cancelled. No password provided."
			return
		fi
        
        
        show_loading_notification "$tr_connecting_to"
		nmcli --wait 15 device wifi connect "$wifi_ssid" ifname "$interface_to_use" password "$wifi_password"
        connection_result=$?
	else
        show_loading_notification "$tr_connecting_to"
		nmcli --wait 15 device wifi connect "$wifi_ssid" ifname "$interface_to_use"
        connection_result=$?
	fi
    kill_loading_notification

	if [ $connection_result -eq 0 ]; then
		send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$wifi_ssid'"
        exit 0
	else
		send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$wifi_ssid'"
	fi
}

# --- IP Configuration Menus ---

# Manage individual IP addresses for a connection
menu_addresses() {
	local connection_uuid="$1"
	local ipv="$2"
	local -a addresses_list
	local sure chosen

	while true; do
		mapfile -t addresses_list < <(nmcli --get-values ipv${ipv}.addresses connection show "$connection_uuid" | sed 's/,/\n/g')
		local options=$(printf "%s\n" "${addresses_list[@]}")
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$tr_menu_addresses_prompt" "") # Pass "" for prompt_icon

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # User cancelled or pressed back
        fi

		local found=0
		for addr in "${addresses_list[@]}"; do
			if [ "$chosen" = "$addr" ]; then
				found=1
				sure=$(echo -e "$icon_check\n$icon_close Back" | display_menu 1 "$tr_menu_addresses_sure_prompt_1 ${chosen}$tr_menu_addresses_sure_prompt_2" "") # Pass "" for prompt_icon
				if [ -z "$sure" ] || [[ "$sure" =~ ^"$icon_close Back" ]]; then continue; fi # User cancelled confirmation
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


# Configure IP method (auto/manual), gateway
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

		chosen=$(echo -e "$options" | display_menu 1 "$chosen_connection_name (IPv$ipv)" "") # Pass "" for prompt_icon

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # User cancelled or pressed back
        fi

		case "$chosen" in
			*"DNS Configuration"*)
				menu_dns "$connection_uuid" "$ipv"
				;;
			*"$tr_autoip_message"*)
				if [ "$autoip_state" = "$icon_on" ]; then
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.method manual
				else
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.method auto
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.gateway ''
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.addresses ''
				fi
				;;
			*"$tr_autodns_message"*)
				if [ "$autodns_state" = "$icon_on" ]; then
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.ignore-auto-dns yes
				else
					nmcli connection modify uuid "$connection_uuid" ipv${ipv}.ignore-auto-dns no
				fi
				;;
			*"$tr_address_message"*)
				menu_addresses "$connection_uuid" "$ipv"
				;;
			*"$tr_gateway_message"*)
				new_gateway=$(echo "$icon_close Back" | display_menu 1 "$tr_menu_ip_config_gateway_prompt" "") # Pass "" for prompt_icon
				if [ -z "$new_gateway" ] || [[ "$new_gateway" =~ ^"$icon_close Back" ]]; then continue; fi
				nmcli connection modify uuid "$connection_uuid" ipv${ipv}.gateway "$new_gateway"
				;;
		esac
	done
}

# Configure DNS servers for a connection
menu_dns() {
	local connection_uuid="$1"
	local ipv="$2"
	local -a dns_list
	local sure chosen

	while true; do
		mapfile -t dns_list < <(nmcli --get-values ipv${ipv}.dns connection show "$connection_uuid" | sed 's/,/\n/g')
		local options=$(printf "%s\n" "${dns_list[@]}")
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$tr_menu_dns_prompt" "") # Pass "" for prompt_icon

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # User cancelled or pressed back
        fi

		local found=0
		for dns_entry in "${dns_list[@]}"; do
			if [ "$chosen" = "$dns_entry" ]; then
				found=1
				sure=$(echo -e "$icon_check\n$icon_close Back" | display_menu 1 "$tr_menu_dns_sure_prompt_1 ${chosen}$tr_menu_dns_sure_prompt_2" "") # Pass "" for prompt_icon
				if [ -z "$sure" ] || [[ "$sure" =~ ^"$icon_close Back" ]]; then continue; fi # User cancelled confirmation
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

	if [ -z "$sure" ] || [[ "$sure" =~ ^"$icon_close Back" ]]; then return 1; fi # User cancelled or pressed back
	if [[ "$sure" =~ ^"$icon_check $tr_forget_connection_confirm" ]]; then
		nmcli connection delete uuid "$connection_uuid" && return 0
	fi
	return 1
}


rename_connection() {
	local connection_uuid="$1"
	local new_name=$(echo "" | display_menu 5 "$tr_rename_connection_prompt" "") # Pass "" for prompt_icon

	if [ -z "$new_name" ]; then return 1; fi # User cancelled or pressed back

	nmcli connection modify uuid "$connection_uuid" connection.id "$new_name"
	return $?
}


edit_connection_password() {
    local connection_uuid="$1"
    local connection_name="$2"
    
    # Prompt for new password
    local pass=$(ask_password "$connection_name")
    
    if [ -z "$pass" ]; then return 1; fi # Cancelled
    
    # Update the connection
    if nmcli connection modify uuid "$connection_uuid" wifi-sec.psk "$pass"; then
        send_notification "$tr_password_updated" "$tr_notice_connected_body '$connection_name'"
        return 0
    else
        send_notification "$tr_password_update_failed" "$tr_notice_error_body '$connection_name'"
        return 1
    fi
}

# Menu for individual connection settings (Wi-Fi)
menu_connection() {
	local chosen_connection_name="$1"
	local connection_uuid="$2"
	local autoconnect_state chosen

    while true; do
		autoconnect_state="$([ "$(nmcli --get-values connection.autoconnect connection show "$connection_uuid")" = "yes" ] && echo "$icon_on" || echo "$icon_off")"

        # Check if this connection is currently active
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
        options+="$icon_password  $tr_edit_password_message\n" # NEW: Edit Password option
        # Only show QR code for Wi-Fi connections
        if [ "$(nmcli -g connection.type connection show "$connection_uuid")" = "802-11-wireless" ]; then
             options+="$icon_qrcode  $tr_qrcode_message\n"
        fi
		options+="$icon_close Back"

		chosen=$(echo -e "$options" | display_menu 1 "$chosen_connection_name" "") # Pass "" for prompt_icon

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # User cancelled or pressed back
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
                show_loading_notification "$tr_connecting_to"
                if nmcli connection up uuid "$connection_uuid"; then
                    kill_loading_notification
                    send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$chosen_connection_name'"
                    exit 0
                else
                    kill_loading_notification
                    # Smart Recovery: Prompt to update password
                    # Check if user wants to retry with new password
                    local retry_choice=$(echo -e "$icon_check Yes\n$icon_close No" | display_menu 2 "$tr_connection_failed_retry" "")
                    if [[ "$retry_choice" =~ ^"$icon_check" ]]; then
                         if edit_connection_password "$connection_uuid" "$chosen_connection_name"; then
                              # Retry connection
                              show_loading_notification "$tr_connecting_to"
                              if nmcli connection up uuid "$connection_uuid"; then
                                   kill_loading_notification
                                   send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$chosen_connection_name'"
                                   exit 0
                              fi
                              kill_loading_notification
                         fi
                    fi
                    send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$chosen_connection_name'"
                fi
                ;;
            "$icon_wifi_disconnected  $tr_disconnect_message")
                 # Disconnect logic
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

# Menu for Wireguard connection settings
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

		chosen=$(echo -e "$options" | display_menu 1 "$chosen_connection_name" "") # Pass "" for prompt_icon

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # User cancelled or pressed back
        fi

		case "$chosen" in
			*"$tr_wireguard_enable_message"*)
				if [ "$state" = "$icon_on" ]; then
					nmcli connection down uuid "$connection_uuid"
				else
					nmcli connection up uuid "$connection_uuid"
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

# Menu for listing and managing known/saved connections
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
            profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_for_type" '$1 ~ /^(wifi|802-11-wireless).*/ {print $2 "\\0" icon "  " $3}')
            prompt_to_use="$tr_known_connections_message" # Use descriptive text for prompt
			;;
		"wireguard")
			icon_for_type="$icon_wireguard"
			menu_type_function="menu_wireguard_connection"
            profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_for_type" '$1 == "wireguard" {print $2 "\\0" icon "  " $3}')
            prompt_to_use="$tr_vpn_menu_prompt" # Use new VPN prompt
			;;
		"ethernet")
			icon_for_type="$icon_ethernet"
			menu_type_function="menu_connection"
            profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_for_type" '$1 ~ /^(ethernet|802-3-ethernet).*/ {print $2 "\\0" icon "  " $3}')
            prompt_to_use="$tr_manage_wired_connections"
			;;
		*) # All saved connections
			icon_for_type="$icon_saved"
			menu_type_function="menu_connection"
            profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon_saved="$icon_saved" -v icon_wireless="$icon_wireless" -v icon_ethernet="$icon_ethernet" -v icon_vpn_disconnect="$icon_vpn_disconnect" '{
                icon_local = icon_saved;
                if ($1 == "wifi" || $1 == "802-11-wireless") icon_local = icon_wireless;
                else if ($1 == "ethernet" || $1 == "802-3-ethernet") icon_local = icon_ethernet;
                else if ($1 == "vpn" || $1 == "wireguard") icon_local = icon_vpn_disconnect;
                print $2 "\\0" icon_local "  " $3 " (" $1 ")"
            }')
            prompt_to_use="$tr_saved_connections_menu_prompt" # Use new Saved Connections prompt
			;;
	esac

    mapfile -t profiles_list < <(echo "$profiles_list_raw")

    if [ "${#profiles_list[@]}" -eq 0 ] || ([ "${#profiles_list[@]}" -eq 1 ] && [ -z "${profiles_list[0]}" ]); then
        display_info_message "$tr_no_saved_connections" "$prompt_to_use" # Pass custom prompt
        return
    fi

	while true; do
		local options=$(for i in "${profiles_list[@]}"; do echo -e "$i" | cut --delimiter $'\0' --fields 2; done)
		options+="\n$icon_close Back" # FIX: Added newline before the Back entry

		# Prompt for this menu is explicitly set by prompt_to_use, no extra icon prepended by display_menu
		chosen=$(echo -e "$options" | display_menu 1 "$prompt_to_use" "") # Pass "" for prompt_icon

		if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return # User cancelled or pressed back
        fi

		for i in "${profiles_list[@]}"; do
			if [ "$chosen" = "$(echo -e "$i" | cut --delimiter $'\0' --fields 2)" ]; then
				local conn_uuid=$(echo -e "$i" | cut --delimiter $'\0' --fields 1)
				local conn_name_display=$(echo "$chosen" | sed -E 's/^(󰋋|󰖩|󰈀|󰖂) //; s/ \(.+\)$//') # Changed 󰖃 to 󰖂
				eval "$menu_type_function \"$(sed 's/"/\\"/g' <<< "$conn_name_display")\" \"$conn_uuid\""
				break
			fi
		done
	done
}

# NEW: Menu for connecting to a specific wired connection
menu_connect_wired_connection() {
    local profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_ethernet" '$1 ~ /^(ethernet|802-3-ethernet).*/ {print $2 "\\0" icon "  " " " $3}')
    mapfile -t profiles_list < <(echo "$profiles_list_raw")

    if [ "${#profiles_list[@]}" -eq 0 ] || ([ "${#profiles_list[@]}" -eq 1 ] && [ -z "${profiles_list[0]}" ]); then
        display_info_message "No saved wired connections to connect to." "$tr_connect_wired_connection" # Pass custom prompt
        return
    fi

    local options=$(for i in "${profiles_list[@]}"; do echo -e "$i" | cut --delimiter $'\0' --fields 2; done)
    options+="\n$icon_close Back"

    # Prompt for this menu is just the search icon
    local chosen=$(echo -e "$options" | display_menu 1 "$tr_connect_wired_connection" "$icon_search")

    if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
        return # User cancelled or pressed back
    fi

    local conn_uuid_to_connect=""
    local conn_name_to_connect=""

    for i in "${profiles_list[@]}"; do
        if [ "$chosen" = "$(echo -e "$i" | cut --delimiter $'\0' --fields 2)" ]; then
            conn_uuid_to_connect=$(echo -e "$i" | cut --delimiter $'\0' --fields 1)
            conn_name_to_connect=$(echo -e "$i" | cut --delimiter $'\0' --fields 2 | sed -E 's/^(󰈀) //') # Remove icon
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
            send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$conn_name_to_connect'"
        fi
    else
        show_message "Could not find connection profile for $conn_name_to_connect." "$tr_connect_wired_connection" # Pass custom prompt
    fi
}

# NEW: Wired Menu
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
        options+="$icon_connect_wired Connect to Wired Connection\n" # FIX: Using icon_connect_wired
        options+="$icon_config $tr_manage_wired_connections\n" # Option to manage profiles
        options+="$icon_close Back"

        local choice=$(echo -e "$options" | display_menu 1 "$tr_wired_menu_prompt" "") # Pass "" for prompt_icon

        if [ -z "$choice" ] || [[ "$choice" =~ ^"$icon_close Back" ]]; then
            return # Go back to parent menu (main_menu)
        fi

        case "$choice" in
            *"Connect to Wired Connection"*)
                menu_connect_wired_connection # Call the function to connect to a wired network
                ;;
            *"$tr_manage_wired_connections"*)
                menu_known_connections "ethernet" # Reuse existing function for managing wired profiles
                ;;
            *"$tr_status_message"*) # Do nothing if status line is selected
                ;;
            *)
                show_message "Invalid option selected: $choice" "$tr_wired_menu_prompt" # Pass custom prompt
                ;;
        esac
    done
}

# --- Status Functions ---

show_active_connection_details() {
    local device="$1"
    local details_raw=$(nmcli --colors no device show "$device")
    
    # Display the raw list in a filterable menu
    local prompt_text="$icon_active_details Active Connection Details: $icon_search"
    echo -e "${details_raw}\n${icon_close} Back" | display_menu 1 "$prompt_text" ""
}

status_menu() {
    local options="$icon_active_details Active Connection Details\n$icon_devices All Device Status\n$icon_close Back"
    # Use new status menu prompt
    local choice=$(echo -e "$options" | display_menu 1 "$tr_status_menu_prompt" "") # Pass "" for prompt_icon

    if [ -z "$choice" ] || [[ "$choice" =~ ^"$icon_close Back" ]]; then
        return # User cancelled or pressed back
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
            display_info_message "$device_status" "$tr_status_menu_prompt" # Pass custom prompt
            ;;
    esac
}

# --- Airplane Mode ---
toggle_airplane_mode() {
    local wifi_state=$(nmcli radio wifi)
    local wwan_state=$(nmcli radio wwan 2>/dev/null || echo "disabled") # WWAN may not exist

    if [ "$wifi_state" = "enabled" ] || [ "$wwan_state" = "enabled" ]; then
        # Disable all radios
        nmcli radio wifi off
        nmcli radio wwan off 2>/dev/null
        show_message "$tr_airplane_on" "$tr_airplane_mode_message"
    else
        # Enable all radios
        nmcli radio wifi on
        nmcli radio wwan on 2>/dev/null
        show_message "$tr_airplane_off" "$tr_airplane_mode_message"
    fi
}

# --- QR Code Sharing ---
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

    # Display QR code inside Rofi
    # -i: Enable icons
    # -theme-str: Override theme to show large icon and no text input
    # Display QR code inside Rofi
    # -i: Enable icons
    # -show-icons: Required to show icons in dmenu mode
    # -theme-str: Override theme to show large icon and no text input
    
    # We use the successful configuration from the test script
    local rofi_override="
        window { width: 500px; }
        listview { lines: 1; scrollbar: false; }
        element { orientation: vertical; padding: 20px; children: [ element-icon, element-text ]; }
        element-icon { enabled: true; size: 300px; horizontal-align: 0.5; }
        element-text { horizontal-align: 0.5; }
        entry { enabled: false; } 
        inputbar { enabled: false; }
    "
    
    # We pass an entry with the icon set to the QR file path
    # Format: Valid Text \0icon\x1f/path/to/image.png
    # We use "Scan to Connect" as the text under the QR code
    echo -e "Scan to Connect\0icon\x1f${qr_file}" | \
    rofi -dmenu -i -show-icons -p "$tr_qrcode_message" -theme "$ROFI_NETWORK_MANAGER_THEME" \
         -theme-str "$rofi_override" >/dev/null

    # Cleanup after Rofi closes
    rm -f "$qr_file" 2>/dev/null
}

# Get password for a known Wi-Fi connection
get_wifi_password() {
    local ssid="$1"
    local uuid=$(nmcli -t -f NAME,UUID connection show | grep "^${ssid}:" | cut -d':' -f2)
    if [ -n "$uuid" ]; then
        nmcli -s -g 802-11-wireless-security.psk connection show "$uuid" 2>/dev/null
    fi
}

# --- Hotspot Creation ---
create_hotspot() {
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
    if nmcli device wifi hotspot ifname "$interface_to_use" ssid "$ssid" password "$password"; then
        kill_loading_notification
        show_message "$tr_hotspot_success\nSSID: $ssid" "$tr_hotspot_message"
    else
        kill_loading_notification
        show_message "$tr_hotspot_error" "$tr_hotspot_message"
    fi
}


# --- VPN Functions ---

import_vpn() {
    local vpn_file_path=$(echo "" | display_menu 5 "$tr_import_vpn_prompt" "")

    if [ -z "$vpn_file_path" ]; then
        return
    fi

    if [ ! -f "$vpn_file_path" ]; then
        send_notification "$tr_notice_import_error_summary" "$tr_notice_file_not_found_body"
        return
    fi

    local vpn_type=""
    case "$vpn_file_path" in
        *.conf) vpn_type="wireguard" ;;
        *.ovpn) vpn_type="openvpn" ;;
        *)
            send_notification "$tr_notice_import_error_summary" "$tr_notice_unknown_vpn_type_body"
            return
            ;;
    esac

    if nmcli connection import type "$vpn_type" file "$vpn_file_path"; then
        send_notification "$tr_notice_import_success_summary" "$tr_notice_import_success_body"
    else
        send_notification "$tr_notice_import_error_summary" "$tr_notice_import_error_body"
    fi
}

toggle_vpn_connection() {
    local uuid="$1"
    local name="$2"
    local state="$3"

    if [ "$state" = "activated" ]; then
        show_loading_notification "$tr_disconnecting_from '$name'..."
        if nmcli connection down uuid "$uuid"; then
            kill_loading_notification
            send_notification "$tr_notice_disconnected_summary" "$tr_notice_disconnected_body '$name'"
            exit 0
        else
            kill_loading_notification
            send_notification "$tr_notice_error_summary" "$tr_notice_error_disconnect_body '$name'"
        fi
    else
        show_loading_notification "$tr_connecting_to"
        if nmcli connection up uuid "$uuid"; then
            kill_loading_notification
            send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$name'"
            exit 0
        else
            kill_loading_notification
            send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$name'"
        fi
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
    local options="$icon_wifi_full  Wi-Fi\n"
    options+="$icon_ethernet  Wired\n"
    options+="$icon_vpn_disconnect  VPN\n"
    options+="$icon_bookmark_saved  Saved Connections\n"
    options+="$icon_status_chart  Status\n"
    options+="$icon_airplane  $tr_airplane_mode_message\n"
    options+="$icon_close Exit"

    while true; do # Keep looping for the main menu
        local choice=$(echo -e "$options" | display_menu 1 "$tr_main_menu_prompt" "") # Pass "" for prompt_icon

        if [ -z "$choice" ]; then
            # If user presses Esc on the main menu, exit the script
            exit 0
        fi

        case "$choice" in
            "$icon_close Exit") exit 0 ;; # Only exit if 'Exit' is explicitly chosen
            *"Wi-Fi")
                menu_wifi
                ;;
            *"Wired")
                menu_wired # Call the new wired sub-menu
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
    done # End of main menu while loop
}

# --- Run ---
main_menu
