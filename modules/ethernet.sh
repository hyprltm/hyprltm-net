# =============================================================================
#                             WIRED MODULE
# =============================================================================

menu_wired() {
    if [ -z "${ethernet_interfaces[0]}" ]; then
        show_error_message "$tr_no_ethernet_device"
        return
    fi

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
        options+="$icon_connect_wired $tr_connect_wired\n"
        options+="$icon_config $tr_manage_wired_connections\n"
        options+="$icon_close Back"

        local choice=$(echo -e "$options" | display_menu 1 "$tr_wired_menu_prompt" "")

        if [ -z "$choice" ] || [[ "$choice" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$choice" in
            *"$tr_connect_wired"*)
                menu_connect_wired_connection
                $DO_EXIT && return
                ;;
            *"$tr_manage_wired_connections"*)
                menu_known_connections "ethernet"
                $DO_EXIT && return
                ;;
            *"$tr_status_message"*)
                ;;
            *)
                show_message "$tr_invalid_option $choice" "$tr_wired_menu_prompt"
                ;;
        esac
    done
}

