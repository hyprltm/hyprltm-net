# =============================================================================
#                     CONNECTION PROFILE MANAGEMENT
# =============================================================================

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

# --- IP Configuration ---

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
        fi
        options+="$icon_ipv4_dns  $tr_dns_config_message\n"
        options+="$icon_close Back"

        chosen=$(echo -e "$options" | display_menu 1 "$chosen_connection_name (IPv$ipv)" "")

        if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
            return
        fi

        case "$chosen" in
            *"$tr_dns_config_message"*)
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

                    local new_addrs=$(echo "" | display_menu 5 "$tr_enter_ip $ex_ip)" "")
                    if [ -z "$new_addrs" ]; then continue; fi

                    local new_gw=$(echo "" | display_menu 5 "$tr_enter_gateway $ex_gw)" "")

                    local new_dns=$(echo "" | display_menu 5 "$tr_enter_dns)" "")

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
                    local new_dns=$(echo "" | display_menu 5 "$tr_enter_dns_simple)" "")
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

# --- Connection Menu ---

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

        local conn_type=$(nmcli -g connection.type connection show "$connection_uuid")
        if [ "$conn_type" = "802-11-wireless" ]; then
             local mac_rand=$(nmcli --get-values wifi.cloned-mac-address connection show "$connection_uuid" 2>/dev/null)
             local mac_random_state="$([ "$mac_rand" = "random" ] && echo "$icon_on" || echo "$icon_off")"
             options+="$icon_devices  $tr_mac_randomization  $mac_random_state\n"
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
                        DO_EXIT=true
                        return
                    else
                        kill_loading_notification
                        local choice=$(show_error_dialog "$output")
                        case "$choice" in
                            *"$tr_try_again") continue ;;
                            *"$tr_edit_password_message")
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
                 show_loading_notification "$tr_disconnecting"
                 if nmcli connection down uuid "$connection_uuid"; then
                    kill_loading_notification
                    send_notification "$tr_notice_disconnected_summary" "$tr_disconnected_body '$chosen_connection_name'"
                    return
                 else
                    kill_loading_notification
                    show_message "$tr_failed_disconnect"
                 fi
                 ;;
            *"$tr_ipv4_config_message"*) menu_ip_config "$chosen_connection_name" "$connection_uuid" "4" ;;
            *"$tr_ipv6_config_message"*) menu_ip_config "$chosen_connection_name" "$connection_uuid" "6" ;;
            *"$tr_forget_message"*) forget_connection "$chosen_connection_name" "$connection_uuid" && return ;;
            *"$tr_rename_connection_message"*)
                if rename_connection "$connection_uuid"; then
                    show_message "$tr_connection_renamed"
                    chosen_connection_name=$(nmcli --get-values connection.id connection show "$connection_uuid")
                else
                    show_message "$tr_failed_rename"
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
            *"$tr_mac_randomization"*)
                local cur_mac=$(nmcli --get-values wifi.cloned-mac-address connection show "$connection_uuid" 2>/dev/null)
                if [ "$cur_mac" = "random" ]; then
                    nmcli connection modify uuid "$connection_uuid" wifi.cloned-mac-address ""
                    show_success_message "$tr_mac_disabled"
                else
                    nmcli connection modify uuid "$connection_uuid" wifi.cloned-mac-address random
                    show_success_message "$tr_mac_enabled"
                fi
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
                    show_message "$tr_connection_renamed"
                    chosen_connection_name=$(nmcli --get-values connection.id connection show "$connection_uuid")
                else
                    show_message "$tr_failed_rename"
                fi
                ;;
            *"$tr_forget_message"*) forget_connection "$chosen_connection_name" "$connection_uuid" && return ;;
        esac
    done
}

# --- Known Connections Browser ---

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

            profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_for_type" '$1 ~ /^(ethernet|802-3-ethernet).*/ {print $2 ";;;" icon "  " " " $3}')
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
        local options=$(for i in "${profiles_list[@]}"; do temp="${i#*;;;}"; echo "${temp%%;;;*}"; done)
        options+="\n$icon_close Back"

        chosen_index=$(echo -e "$options" | display_menu 1 "$prompt_to_use" "$icon_saved" "-format i")

        if [ -z "$chosen_index" ]; then
            return
        fi

        if [ "$chosen_index" -eq "${#profiles_list[@]}" ]; then
             return
        fi

        local selected_item="${profiles_list[$chosen_index]}"

        local conn_uuid="${selected_item%%;;;*}"
        local conn_real_name="${selected_item##*;;;}"

        case "$menu_type_function" in
            menu_connection)
                menu_connection "$conn_real_name" "$conn_uuid"
                ;;
            menu_wireguard_connection)
                menu_wireguard_connection "$conn_real_name" "$conn_uuid"
                ;;
        esac
        $DO_EXIT && return
    done
}

menu_connect_wired_connection() {
    local profiles_list_raw=$(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' -v icon="$icon_ethernet" '$1 ~ /^(ethernet|802-3-ethernet).*/ {print $2 ";;;" icon "  " " " $3}')
    mapfile -t profiles_list < <(echo "$profiles_list_raw")

    if [ "${#profiles_list[@]}" -eq 0 ] || ([ "${#profiles_list[@]}" -eq 1 ] && [ -z "${profiles_list[0]}" ]); then
        display_info_message "$tr_no_saved_wired" "$tr_connect_wired_connection"
        return
    fi

    local options=$(for i in "${profiles_list[@]}"; do echo -e "${i#*;;;}"; done)
    options+="\n$icon_close Back"

    local chosen=$(echo -e "$options" | display_menu 1 "$tr_connect_wired_connection" "$icon_search")

    if [ -z "$chosen" ] || [[ "$chosen" =~ ^"$icon_close Back" ]]; then
        return
    fi

    local conn_uuid_to_connect=""
    local conn_name_to_connect=""

    for i in "${profiles_list[@]}"; do
        local display_name="${i#*;;;}"
        if [ "$chosen" = "$display_name" ]; then
            conn_uuid_to_connect="${i%%;;;*}"
            conn_name_to_connect=$(echo "$display_name" | sed -E 's/^(󰈀) //')
            break
        fi
    done

    if [ -n "$conn_uuid_to_connect" ]; then
        show_loading_notification "$tr_connecting_to '$conn_name_to_connect'..."
        if nmcli connection up uuid "$conn_uuid_to_connect"; then
            kill_loading_notification
            if ! check_captive_portal "$conn_name_to_connect"; then
                send_notification "$tr_notice_connected_summary" "$tr_notice_connected_body '$conn_name_to_connect'"
            fi
            DO_EXIT=true
            return
        else
            kill_loading_notification
            send_notification "$tr_notice_error_summary" "$tr_notice_error_body '$conn_name_to_connect'" "error"
        fi
    else
        show_message "$tr_no_connection_profile $conn_name_to_connect." "$tr_connect_wired_connection"
    fi
}

