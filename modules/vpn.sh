# =============================================================================
#                               VPN MODULE
# =============================================================================

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
            DO_EXIT=true
            return
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
                DO_EXIT=true
                return
            else
                kill_loading_notification

                local choice=$(show_error_dialog "$output")
                case "$choice" in
                    *"$tr_try_again") continue ;;
                    *"$tr_edit_password_message")
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
        mapfile -t vpn_list < <(nmcli --colors no -t -f TYPE,UUID,NAME connection show | awk -F ':' '$1 == "vpn" || $1 == "wireguard" {print $2 ";;;" $3}')

        if [ "${#vpn_list[@]}" -eq 0 ] || [ -z "${vpn_list[0]}" ]; then
            display_info_message "$tr_no_configured_vpns" "$tr_available_vpn_profiles_message"
            return
        fi

        local options=""
        for i in "${vpn_list[@]}"; do
            local uuid="${i%%;;;*}"
            local name="${i#*;;;}"
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
            local uuid="${i%%;;;*}"
            local name="${i#*;;;}"
            if [ "$name" = "$chosen_name" ]; then
                local state=$(nmcli --get-values GENERAL.STATE connection show uuid "$uuid")
                toggle_vpn_connection "$uuid" "$name" "$state"
                $DO_EXIT && return
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
                $DO_EXIT && return
                ;;
            *"$tr_import_vpn_message"*)
                import_vpn
                ;;
        esac
    done
}

