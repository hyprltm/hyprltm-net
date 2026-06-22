# modules/core.sh — Config, icons, helpers, connection management, status & main menus

# --- Dependencies Check ---
if ! command -v rofi &> /dev/null; then
    echo "$tr_startup_no_rofi" >&2
    exit 1
fi
if ! command -v nmcli &> /dev/null; then
    echo "$tr_startup_no_nmcli" >&2
    exit 1
fi

# =============================================================================
#                           CONFIGURATION & THEMING
# =============================================================================

ROFI_THEME_NAME="${ROFI_THEME_NAME:-hyprltm-net}"

if [[ -n "${ROFI_NETWORK_MANAGER_THEME:-}" && ! -r "$ROFI_NETWORK_MANAGER_THEME" ]]; then
    echo "$tr_startup_bad_theme ($ROFI_NETWORK_MANAGER_THEME) not found or not readable. Falling back to auto-detection." >&2
    unset ROFI_NETWORK_MANAGER_THEME
fi

if [[ -z "${ROFI_NETWORK_MANAGER_THEME:-}" ]]; then
    for _dir in "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes" \
               "${XDG_CONFIG_HOME:-$HOME/.config}/hyprltm/themes" \
               "/usr/share/rofi/themes" \
               "/etc/xdg/rofi/themes" \
               "$HOME/.local/share/rofi/themes" \
               "$_script_dir"; do
        if [[ -r "$_dir/${ROFI_THEME_NAME}.rasi" ]]; then
            ROFI_NETWORK_MANAGER_THEME="$_dir/${ROFI_THEME_NAME}.rasi"
            break
        fi
    done
fi

if [[ -z "${ROFI_NETWORK_MANAGER_THEME:-}" ]]; then
    ROFI_NETWORK_MANAGER_THEME="${ROFI_THEME_NAME}"
fi

if [[ "$ROFI_NETWORK_MANAGER_THEME" != "${ROFI_THEME_NAME}" ]]; then
    theme_dir="$(dirname "$ROFI_NETWORK_MANAGER_THEME")"
    if [[ ! -r "$theme_dir/ltmnight.rasi" ]]; then
        echo "$tr_warn_missing_rasi $ROFI_NETWORK_MANAGER_THEME$tr_warn_missing_rasi_colors" >&2
    fi
fi

unset _dir _script_dir

if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/hyprltm/hyprltm-net.conf" ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/hyprltm/hyprltm-net.conf"
fi

# =============================================================================
#                                  ICONS
# =============================================================================

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
icon_wifi_fair="${icon_wifi_fair:-"󰤟"}"
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
icon_browser="${icon_browser:-"󰖟"}"
icon_speedtest="${icon_speedtest:-"󰓅"}"

icon_error="${icon_error:-"󰅖"}"
icon_warning="${icon_warning:-"󰀦"}"
icon_cancelled="${icon_cancelled:-"󰍶"}"
icon_timeout="${icon_timeout:-"󰔟"}"
icon_download="${icon_download:-"󰁅"}"
icon_upload="${icon_upload:-"󰁝"}"
icon_ping="${icon_ping:-"󰅐"}"

# Prompts that use icons (set after icons are defined)
tr_main_menu_prompt="$icon_network Network Manager: $icon_search"
tr_wifi_menu_prompt="$icon_wifi_prompt Wi-Fi: $icon_search"
tr_wired_menu_prompt="$icon_ethernet Wired: $icon_search"
tr_vpn_menu_prompt="$icon_vpn_disconnect VPN: $icon_search"
tr_saved_connections_menu_prompt="$icon_bookmark_saved Saved Connections: $icon_search"
tr_status_menu_prompt="$icon_status_chart Status: $icon_search"

# --- Global Variables ---
program_name="$(basename "$0")"
LOADING_ROFI_PID=""

# Detect interfaces
mapfile -t wifi_interfaces < <(nmcli --colors no -t -f TYPE,DEVICE device status | awk -F ':' '$1 == "wifi" {print $2}')
mapfile -t ethernet_interfaces < <(nmcli --colors no -t -f TYPE,DEVICE device status | awk -F ':' '$1 ~ /^(ethernet|802-3-ethernet)/ {print $2}')

if [ -z "${wifi_interfaces[0]}" ] && [ -z "${ethernet_interfaces[0]}" ]; then
	echo "$program_name: No Wi-Fi or Ethernet interfaces detected." >&2
	exit 2
fi

if [ -n "${wifi_interfaces[0]}" ]; then
    interfaces=("${wifi_interfaces[@]}")
    interface_to_use="${wifi_interfaces[0]}"
else
    interfaces=("${ethernet_interfaces[@]}")
    interface_to_use="${ethernet_interfaces[0]}"
fi

# =============================================================================
#                               ROFI WRAPPERS
# =============================================================================

display_menu() {
	local form="$1"
	local prompt_text="$2"
	local prompt_icon="${3:-}"
    local extra_flags="${4:-}"
    local mesg_text="${5:-}"
    local rofi_prompt rofi_flags options_list mesg_processed
    local -a rofi_base_args=()

	if [ -n "$prompt_icon" ] && ! echo "$prompt_text" | grep -qE "^$prompt_icon"; then
		rofi_prompt="$prompt_icon $prompt_text"
	else
		rofi_prompt="$prompt_text"
	fi

    if [ -n "$mesg_text" ]; then
        printf -v mesg_processed "%b" "$mesg_text"
        rofi_base_args=(-mesg "$mesg_processed")
    fi

	local result

	case $form in
		1)
            rofi_flags="-dmenu -i"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags "${rofi_base_args[@]}" $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME")
            ;;
		2)
            rofi_flags="-dmenu"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags "${rofi_base_args[@]}" $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME")
            ;;
		3)
            rofi_flags="-dmenu -password"
            result=$(rofi $rofi_flags $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#listview { enabled: false; }')
            ;;
        4)
            rofi_flags="-dmenu -i"
            options_list=$(cat)
            result=$(echo -e "$options_list" | rofi $rofi_flags "${rofi_base_args[@]}" $extra_flags -p "$rofi_prompt" -theme "$ROFI_NETWORK_MANAGER_THEME" -theme-str '#inputbar { enabled: false; }')
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
    local icon="$icon_error"

    raw_msg="${raw_msg%%Hint:*}"

    raw_msg="${raw_msg#Error: }"

    raw_msg="$(echo "$raw_msg" | xargs)"

    case "$raw_msg" in
        *"Secrets were required"*)
            icon=""
            clean_msg="$tr_clean_incorrect_pwd"
            ;;
        *"No network with SSID"*|*"network could not be found"*)
            icon="󰐷"
            clean_msg="$tr_clean_network_not_found"
            ;;
        *"activation failed"*)
             icon="$icon_warning"
             clean_msg="$tr_clean_refused"
             ;;
        *"Timeout"*)
             icon="$icon_timeout"
             clean_msg="$tr_clean_timeout"
             ;;
        *"cancelled"*)
             icon="$icon_cancelled"
             clean_msg="$tr_clean_cancelled"
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

    local options="$icon_refresh $tr_try_again\n$icon_password $tr_edit_password_message\n$icon_close Cancel"

    echo -e "$options" | rofi -dmenu -i -p "$icon_warning $tr_connection_failed" \
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
             show_error_message "$icon_error $body"
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
    local msg=$(printf "%b" "$icon $1")
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
        -p "$tr_success" \
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
        -p "$tr_error" \
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

        local action_choice=$(echo -e "$options" | display_menu 1 "$tr_password_actions" "")

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

    show_loading_notification "$tr_gathering_details"

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

show_active_connection_details() {
    local device="$1"
    local details_raw=$(nmcli --colors no device show "$device")

    local prompt_text="$icon_active_details Active Connection Details: $icon_search"
    echo -e "${details_raw}\n${icon_close} Back" | display_menu 1 "$prompt_text" ""
}

check_captive_portal() {
    local ssid="$1"
    sleep 2
    local connectivity=$(nmcli networking connectivity check 2>/dev/null)

    if [ "$connectivity" = "portal" ]; then
        local options="$icon_browser $tr_open_browser\n$icon_close Dismiss"
        local chosen=$(echo -e "$options" | display_menu 1 "$tr_captive_portal_title\n$tr_captive_portal_message" "$icon_info")

        if [[ "$chosen" == *"$tr_open_browser"* ]]; then
            local native_uri=$(NetworkManager --print-config 2>/dev/null | grep -i "^uri=" | cut -d'=' -f2-)
            if [ -n "$native_uri" ]; then
                xdg-open "$native_uri" &>/dev/null
            else
                xdg-open "http://nmcheck.gnome.org" &>/dev/null
            fi
        fi
        return 0
    fi
    return 1
}


# =============================================================================
#                                   STATUS
# =============================================================================

status_menu() {
    local options="$icon_active_details $tr_active_connection_details\n$icon_devices $tr_all_device_status\n$icon_speedtest $tr_speedtest_menu\n$icon_close Back"

    while true; do
        local choice=$(echo -e "$options" | display_menu 1 "$tr_status_menu_prompt" "")

        if [ -z "$choice" ] || [[ "$choice" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$choice" in
            *"$tr_active_connection_details")
                local active_conn_device=$(nmcli -t -f DEVICE connection show --active | head -n 1)
                if [ -z "$active_conn_device" ]; then
                    display_info_message "$tr_no_active_connection"
                else
                    show_active_connection_details "$active_conn_device"
                fi
                ;;
            *"$tr_all_device_status")
                local device_status=$(nmcli device status)
                echo -e "$device_status\n$icon_close Back" | display_menu 1 "$tr_status_menu_prompt" ""
                ;;
            *"$tr_speedtest_menu")
                run_speedtest
                ;;
        esac
    done
}

# =============================================================================
#                                 QR CODE
# =============================================================================

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

    echo -e "$tr_scan_to_connect\0icon\x1f${qr_file}" | \
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

# =============================================================================
#                            BT TETHER MENU
# =============================================================================

menu_bt_tether() {
    if ! command -v bluetoothctl &> /dev/null; then
        show_error_message "$tr_btctl_not_found"
        return
    fi

    if ! bluetoothctl show 2>/dev/null | grep -q "Powered:"; then
        show_error_message "$tr_bt_no_adapter"
        return
    fi

    if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
        local choice=$(echo -e "$icon_bluetooth  $tr_bt_power_on\n$icon_close $tr_cancel" | display_menu 1 "$tr_bt_is_off" "$icon_bluetooth")
        [[ "$choice" != *"$tr_bt_power_on"* ]] && return
        show_loading_notification "$icon_bluetooth $tr_bt_powering"
        timeout 5 bluetoothctl power on &>/dev/null
        kill_loading_notification
        if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
            show_error_message "$tr_bt_power_failed"
            return
        fi
    fi

    local mac name line bt_options=""
    local idx=0
    declare -a bt_addrs bt_names bt_paired

    while true; do
        show_loading_notification "$tr_bt_scanning"
        bluetoothctl -- scan on &>/dev/null &
        local scan_pid=$!
        disown "$scan_pid" 2>/dev/null
        sleep 8
        kill "$scan_pid" 2>/dev/null
        wait "$scan_pid" 2>/dev/null
        kill_loading_notification

        bt_options=""
        idx=0
        bt_addrs=()
        bt_names=()
        bt_paired=()

        local all_devices=$(timeout 5 bluetoothctl devices 2>/dev/null | sort -u)
        local paired_list=$(timeout 5 bluetoothctl paired-devices 2>/dev/null | awk '{print $2}')

        while IFS= read -r line; do
            [ -z "$line" ] && continue
            mac=$(echo "$line" | awk '{print $2}')
            name=$(echo "$line" | awk '{for(i=3;i<=NF;i++) printf "%s%s", (i>3 ? OFS : ""), $i; print ""}')
            [ -z "$mac" ] && continue

            local is_paired=0
            echo "$paired_list" | grep -qF "$mac" && is_paired=1

            local existing_uuid=$(nmcli -t -f UUID,NAME connection show 2>/dev/null | grep -iF "BT-$name" | head -1 | cut -d: -f1)

            if [ "$is_paired" -eq 1 ] && [ -n "$existing_uuid" ]; then
                local conn_state=$(nmcli -t -f UUID,DEVICE connection show --active | grep "^$existing_uuid" | head -1)
                local status=""
                [ -n "$conn_state" ] && status=" (Connected)"
                bt_options+="$icon_bluetooth  $name$status\n"
            elif [ "$is_paired" -eq 1 ]; then
                bt_options+="$icon_bluetooth  $name — $tr_bt_connect\n"
            else
                bt_options+="$icon_bluetooth  $name — $tr_bt_pair_connect\n"
            fi
            bt_addrs[$idx]="$mac"
            bt_names[$idx]="$name"
            bt_paired[$idx]="$is_paired"
            ((idx++))
        done <<< "$all_devices"

        [ -z "$bt_options" ] && { display_info_message "$tr_bt_no_devices" "" "$icon_bluetooth"; return; }
        bt_options+="\n$icon_refresh $tr_bt_rescan\n$icon_close Back"

        local choice=$(echo -e "$bt_options" | display_menu 1 "$tr_bt_select_device" "$icon_bluetooth")
        [ -z "$choice" ] && return
        [[ "$choice" == "$icon_close Back" ]] && return
        [[ "$choice" == *"$tr_bt_rescan" ]] && continue

        for ((i=0; i<idx; i++)); do
            if [[ "$choice" == *"${bt_names[$i]}"* ]]; then
                mac="${bt_addrs[$i]}"
                name="${bt_names[$i]}"

                if [ "${bt_paired[$i]}" -eq 0 ]; then
                    while true; do
                        show_loading_notification "$tr_bt_pairing"
                        local pair_out=$(echo -e "agent NoInputNoOutput\ndefault-agent\npair $mac\ntrust $mac\nquit" | timeout 20 bluetoothctl 2>&1)
                        kill_loading_notification
                        if bluetoothctl paired-devices 2>/dev/null | grep -qF "$mac"; then
                            break
                        fi
                        local choice=$(show_error_dialog "$pair_out")
                        case "$choice" in
                            *"$tr_try_again"|*"$tr_edit_password_message") continue ;;
                            *) send_notification "$tr_bt_pair_failed" "$name" "error"; return ;;
                        esac
                    done
                fi

                local uuid=$(nmcli -t -f UUID,NAME connection show 2>/dev/null | grep -iF "BT-$name" | head -1 | cut -d: -f1)

                if [ -z "$uuid" ]; then
                    local profile_name="BT-$name"
                    while true; do
                        show_loading_notification "$icon_bluetooth $tr_bt_creating_profile"
                        local add_out=$(timeout 10 nmcli connection add type bluetooth con-name "$profile_name" bluetooth.type panu bluetooth.bdaddr "$mac" 2>&1)
                        local add_r=$?
                        kill_loading_notification
                        if [ $add_r -eq 0 ]; then
                            uuid=$(nmcli -t -f UUID,NAME connection show 2>/dev/null | grep -iF "BT-$name" | head -1 | cut -d: -f1)
                            break
                        fi
                        local choice=$(show_error_dialog "$add_out")
                        case "$choice" in
                            *"$tr_try_again"|*"$tr_edit_password_message") continue ;;
                            *) send_notification "$tr_bt_create_failed" "$name" "error"; return ;;
                        esac
                    done
                fi

                while true; do
                    show_loading_notification "$tr_bt_connecting"
                    local up_out=$(timeout 10 nmcli connection up "$uuid" 2>&1)
                    local r=$?
                    kill_loading_notification
                    if [ $r -eq 0 ]; then
                        send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$name'"
                        return
                    fi
                    local choice=$(show_error_dialog "$up_out")
                    case "$choice" in
                        *"$tr_try_again"|*"$tr_edit_password_message") continue ;;
                        *) send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$name'" "error"; return ;;
                    esac
                done
            fi
        done
    done
}

# =============================================================================
#                               MAIN MENU
# =============================================================================

main_menu() {

    if ! is_notification_service_running; then
        show_warning_dialog "$icon_warning $tr_warn_no_notification" "$tr_warn_no_notification_desc"
    fi

    local options="$icon_wifi_full  $tr_wifi\n"
    options+="$icon_ethernet  $tr_wired\n"
    options+="$icon_vpn_disconnect  $tr_vpn_short\n"
    options+="$icon_bookmark_saved  $tr_saved_connections\n"
    options+="$icon_status_chart  $tr_status_short\n"
    options+="$icon_airplane  $tr_airplane_mode_message\n"
    options+="$icon_close Exit"

    while true; do
        local choice=$(echo -e "$options" | display_menu 1 "$tr_main_menu_prompt" "")

        if [ -z "$choice" ]; then
            exit 0
        fi

        case "$choice" in
            "$icon_close Exit") exit 0 ;;
            *"$tr_wifi")
                menu_wifi
                ;;
            *"$tr_wired")
                menu_wired
                ;;
            *"$tr_vpn_short")
                vpn_menu
                ;;
            *"$tr_saved_connections")
                menu_known_connections "all"
                ;;
            *"$tr_status_short")
                status_menu
                ;;
            *"$tr_airplane_mode_message")
                toggle_airplane_mode
                ;;
        esac
    done
}

