# =============================================================================
#                              WI-FI MODULE
# =============================================================================

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
        -v icon_wifi_fair="$icon_wifi_fair" \
        -v icon_wifi_low="$icon_wifi_low" \
        -v icon_check="$icon_check" \
        -v icon_unlock="$icon_unlock" \
        -v known_ssids="$known_ssids" \
    '
    BEGIN { x = 1 }
    {

        wifi_signal_icon = icon_wifi_low;
        if ($2 > 80) wifi_signal_icon = icon_wifi_full;
        else if ($2 > 60) wifi_signal_icon = icon_wifi_good;
        else if ($2 > 40) wifi_signal_icon = icon_wifi_medium;
        else if ($2 > 20) wifi_signal_icon = icon_wifi_fair;

        ssid = $3;
        if (ssid == "") ssid = "<hidden>";

        status_icon = icon_unlock;

        if ($4 == "*") {
             status_icon = icon_check;
        } else if ($1 ~ /^WPA/) {
             status_icon = icon_wifi_secure;
        }

        formatted_entry = wifi_signal_icon " " status_icon " " ssid " (" $2 "%)";
        full_entry = formatted_entry ";;;" ssid ";;;" $1 ";;;" status_icon ";;;" $2;

        if ($4 == "*") {
            networks[0] = full_entry;
        } else {
            networks[x++] = full_entry;
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
            mapfile -t wifi_array <<< "$wifi_list"
            for item in "${wifi_array[@]}"; do
                options+="${item%%;;;*}\n"
            done
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
                local full_line=$(grep -F "$chosen;;;" <<< "$wifi_list" | head -n 1)
                connect_wifi "$full_line"
                $DO_EXIT && return
                ;;
        esac
    done
}

select_interface() {
    local chosen_interface=$( (for (( i = 0; i < ${#interfaces[@]}; i++ )); do echo "$icon_interface  ${interfaces[$i]}" ; done; echo "$icon_close Back") | display_menu 1 "$tr_select_interface_prompt" "")

    if [ -z "$chosen_interface" ]; then
        return
    elif [[ "$chosen_interface" =~ ^"$icon_close Back" ]]; then
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
        show_message "$tr_cancelled_no_password"
        return
    fi

    while true; do
        show_loading_notification "$tr_connecting_to '$wifi_name'$tr_please_wait"
        output=$(nmcli --wait 15 device wifi connect "$wifi_name" hidden yes password "$wifi_password" 2>&1)

        if [ $? -eq 0 ]; then
            kill_loading_notification
            if ! check_captive_portal "$wifi_name"; then
                send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$wifi_name'"
            fi
            DO_EXIT=true
            return
        else
            kill_loading_notification

            local choice=$(show_error_dialog "$output")
            case "$choice" in
                *"$tr_try_again") continue ;;
                *"$tr_edit_password_message")
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

    local wifi_ssid
    local is_secure="no"
    local sec_icon

    if [[ "$chosen_entry" != *";;;"* ]]; then
        local temp_ssid=$(echo "$chosen_entry" | sed -E 's/ \([0-9]+%\).*$//')
        wifi_ssid=$(echo "$temp_ssid" | sed -E 's/^(󰤨 |󰤥 |󰤢 |󰤯 |󰤫 |󰤪 | | | )+//' | xargs)
        is_secure=$(echo "$chosen_entry" | grep -q "$icon_wifi_secure" && echo "yes" || echo "no")
        sec_icon=$(echo "$chosen_entry" | grep -q "$icon_check" && echo "$icon_check" || echo "")
    else
        local temp="${chosen_entry#*;;;}"
        wifi_ssid="${temp%%;;;*}"
        temp="${temp#*;;;}"
        local raw_sec="${temp%%;;;*}"
        temp="${temp#*;;;}"
        sec_icon="${temp%%;;;*}"

        if [[ "$raw_sec" == WPA* || "$raw_sec" == WEP* || "$raw_sec" == 802.1X* ]]; then
            is_secure="yes"
        fi
    fi

    if [ "$sec_icon" = "$icon_check" ]; then
        local active_uuid=$(nmcli -t -f UUID,TYPE,ACTIVE connection show | grep ":802-11-wireless:yes" | cut -d':' -f1 | head -n1)
        if [ -n "$active_uuid" ]; then
             menu_connection "$wifi_ssid" "$active_uuid"
             return
        fi
    fi

    local active_ssid=$(nmcli -t -f active,ssid dev wifi | grep "^yes" | cut -d':' -f2)
    if [ "$wifi_ssid" = "$active_ssid" ]; then
        local active_uuid=$(nmcli -t -f UUID,TYPE,ACTIVE connection show | grep ":802-11-wireless:yes" | cut -d':' -f1 | head -n1)
        if [ -n "$active_uuid" ]; then
             menu_connection "$wifi_ssid" "$active_uuid"
             return
        fi
        show_message "$tr_already_connected $wifi_ssid."
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
            show_message "$tr_cancelled_no_password"
            return
        fi
    fi

    while true; do
        local existing_uuid=""

        while IFS=: read -r uuid name ssid; do
            if [ "$ssid" = "$wifi_ssid" ]; then
                existing_uuid="$uuid"
                break
            fi
            if [ "$name" = "$wifi_ssid" ]; then
                existing_uuid="$uuid"
                break
            fi
        done < <(nmcli -t -f UUID,NAME,802-11-wireless.ssid connection show)

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
            if ! check_captive_portal "$wifi_ssid"; then
                send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$wifi_ssid'"
            fi
            DO_EXIT=true
            return
        else
            local choice=$(show_error_dialog "$output")
            case "$choice" in
                *"$tr_try_again") continue ;;
                *"$tr_edit_password_message")
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

menu_wifi() {
    local connection_state options chosen

    if [ -z "${wifi_interfaces[0]}" ]; then
        show_error_message "$tr_no_wifi_interface"
        return
    fi

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
        full_options+="$icon_hotspot  $tr_hotspot_menu_prompt\n"
        full_options+="$icon_bluetooth  $tr_bt_tether_menu\n"
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
            "$icon_wireless  $tr_available_networks_message")
                menu_available_wifi_networks
                $DO_EXIT && return
                ;;
            *"$tr_known_connections_message"*)
                menu_known_connections "wifi"
                $DO_EXIT && return
                ;;
            *"$tr_hidden_message"*)
                connect_hidden
                $DO_EXIT && return
                ;;
            *"$tr_hotspot_menu_prompt"*)
                menu_hotspot
                $DO_EXIT && return
                ;;
            *"$tr_bt_tether_menu"*)
                menu_bt_tether
                $DO_EXIT && return
                ;;
            *"$tr_status_message"*)
                if [ -n "$active_uuid" ]; then
                    show_connection_details "$active_ssid" "${interface_to_use}"
                fi
                ;;
            *)
                show_message "$tr_invalid_option $chosen"
                ;;
        esac
    done
}

