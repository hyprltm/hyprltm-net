# =============================================================================
#                             HOTSPOT MODULE
# =============================================================================

menu_manage_hotspot_profile() {
    local uuid="$1"
    local name="$2"

    while true; do

        local is_active=$(nmcli -t -f UUID,STATE connection show --active | grep "$uuid" | grep -q "activated" && echo "yes" || echo "no")
        local toggle_icon="$([ "$is_active" = "yes" ] && echo "$icon_on" || echo "$icon_off")"
        local toggle_text="$([ "$is_active" = "yes" ] && echo "$tr_stop_hotspot" || echo "$tr_enable_hotspot")"

        local options=""
        options+="$icon_hotspot  $toggle_text  $toggle_icon\n"
        options+="$icon_password  $tr_edit_password_message\n"
        options+="$icon_pen  $tr_rename_connection_message\n"
        options+="$icon_qrcode  $tr_qrcode_message\n"
        options+="$icon_trash  $tr_delete_hotspot_profile\n"
        options+="$icon_close Back"

        local chosen=$(echo -e "$options" | display_menu 1 "$tr_manage '$name'" "$icon_hotspot")

        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$chosen" in
            *"$toggle_text"*)
                if [ "$is_active" = "yes" ]; then
                    show_loading_notification "$tr_hotspot_stopping"
                    nmcli connection down uuid "$uuid"
                    kill_loading_notification
                else
                     local active_wifi=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ":wifi:${interface_to_use}")
                     if [ -n "$active_wifi" ]; then
                         if ! show_warning_dialog "$icon_warning $tr_wifi_disconnect_title" "$tr_hotspot_will_disconnect"; then continue; fi
                        nmcli device disconnect "$interface_to_use" &> /dev/null
                     fi

                    show_loading_notification "$tr_hotspot_starting"
                    if nmcli connection up uuid "$uuid"; then
                        kill_loading_notification
                        send_notification "$tr_hotspot_started" "$tr_hotspot_active $name"
                    else
                        kill_loading_notification
                        show_message "$tr_failed_start_hotspot"
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
            *"$tr_delete_hotspot_profile"*)
                if forget_connection "$name" "$uuid"; then
                    show_message "$tr_hotspot_profile_deleted"
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
            display_info_message "$tr_no_saved_hotspots" "$tr_saved_hotspots_title"
            return
        fi

        local options=""
        for item in "${hotspot_list[@]}"; do
             local name="${item#*;;;}"
             options+="$icon_hotspot  $name\n"
        done
        options+="$icon_close Back"

        local chosen_index=$(echo -e "$options" | display_menu 1 "$tr_saved_hotspots_title" "$icon_hotspot" "-format i")

        if [ -z "$chosen_index" ]; then
            return
        fi

        if [ "$chosen_index" -eq "${#hotspot_list[@]}" ]; then
             return
        fi

        local selected_item="${hotspot_list[$chosen_index]}"
        local uuid="${selected_item%%;;;*}"
        local name="${selected_item#*;;;}"

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

        options+="$icon_bookmark_saved  $tr_manage_saved_hotspots\n"
        options+="$icon_hotspot  $tr_create_hotspot\n"
        options+="$icon_close Back"

        local header="$status_line"
        local chosen=$(echo -e "$options" | display_menu 1 "$tr_hotspot_menu_prompt" "$icon_hotspot")

        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$chosen" in
            *"$tr_create_hotspot"*)
                create_hotspot
                ;;
            *"$tr_manage_saved_hotspots"*)
                menu_saved_hotspots
                ;;
        esac
    done
}

create_hotspot() {

    if ! command -v dnsmasq &> /dev/null; then
        show_message "$icon_error $tr_hotspot_no_dnsmasq" "$tr_hotspot_message"
        return
    fi

    local active_connection=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ":802-11-wireless:${interface_to_use}")

    if [ -n "$active_connection" ]; then
        if ! show_warning_dialog "$icon_warning $tr_wifi_disconnect_title" "$tr_hotspot_disconnect_msg"; then
            return
        fi

        show_loading_notification "$tr_disconnecting_wifi"
        nmcli device disconnect "$interface_to_use" &> /dev/null
        kill_loading_notification
    fi

    local ssid=$(echo "" | display_menu 5 "$tr_hotspot_ssid_prompt" "")
    if [ -z "$ssid" ]; then
        return
    fi

    local password=$(echo "" | display_menu 3 "$tr_hotspot_password_prompt" "")
    if [ -z "$password" ] || [ ${#password} -lt 8 ]; then
        show_message "$tr_password_min_length" "$tr_hotspot_message"
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

            send_notification "$tr_hotspot_created" "$tr_hotspot_success\nSSID: $ssid"
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

