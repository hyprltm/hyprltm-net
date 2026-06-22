# =============================================================================
#                             AIRPLANE MODE MODULE
# =============================================================================

toggle_airplane_mode() {
    show_loading_notification "$tr_checking_radio_states"

    local wifi_state=$(nmcli radio wifi)
    local wwan_state=$(timeout 3 nmcli radio wwan 2>/dev/null || echo "disabled")
    kill_loading_notification

    local has_wifi=$(nmcli -t -f TYPE device 2>/dev/null | grep -c "wifi")
    local has_modem=$(nmcli -t -f TYPE device 2>/dev/null | grep -cE "gsm|wwan")
    local has_bt=false
    [ -d /sys/class/bluetooth ] && [ "$(ls -A /sys/class/bluetooth 2>/dev/null)" ] && has_bt=true

    local bt_on=false
    $has_bt && command -v bluetoothctl &>/dev/null && timeout 3 bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && bt_on=true

    local wifi_on=false
    if [ "$has_wifi" -gt 0 ] && [ "$wifi_state" = "enabled" ]; then
        wifi_on=true
    fi
    local wwan_on=false
    if [ "$has_modem" -gt 0 ] && [ "$wwan_state" = "enabled" ]; then
        wwan_on=true
    fi
    local any_on=false; $wifi_on || $wwan_on || $bt_on && any_on=true

    local wifi_text="$tr_off"; $wifi_on && wifi_text="$tr_on"
    local bt_text="$tr_off"; $bt_on && bt_text="$tr_on"
    local wwan_text="$tr_off"; $wwan_on && wwan_text="$tr_on"

    local wifi_status="$icon_off"; $wifi_on && wifi_status="$icon_on"
    local ap_status="$icon_off"; $any_on && ap_status="$icon_on"

    local wifi_icon="$icon_wifi_enable"
    local wifi_label="$tr_enable_wifi"
    if $wifi_on; then
        wifi_icon="$icon_wifi_disable"
        wifi_label="$tr_disable_wifi_only"
    fi

    local ap_icon="$icon_airplane_on"
    $any_on && ap_icon="$icon_airplane_off"

    local status_text=""
    if [ "$has_wifi" -gt 0 ]; then
        status_text="$icon_wifi_full  $tr_wifi:  $wifi_text"
    else
        status_text="$icon_wifi_full  $tr_wifi:  $tr_no_adapter"
    fi
    if $has_bt; then
        status_text="$status_text\n$icon_bluetooth  $tr_bt_label:  $bt_text"
    else
        status_text="$status_text\n$icon_bluetooth  $tr_bt_label:  $tr_no_adapter"
    fi
    if [ "$has_modem" -gt 0 ]; then
        status_text="$status_text\n$icon_wireless  $tr_mobile_label:  $wwan_text"
    else
        status_text="$status_text\n$icon_wireless  $tr_mobile_label:  $tr_no_modem"
    fi

    local options=""
    if [ "$has_wifi" -gt 0 ] || $has_bt || [ "$has_modem" -gt 0 ]; then
        options+="$ap_icon  $tr_full_airplane  $ap_status\n"
    fi
    if [ "$has_wifi" -gt 0 ]; then
        options+="$wifi_icon  $wifi_label  $wifi_status\n"
    fi
    options+="$icon_close Back"

    local choice=$(echo -e "$options" | display_menu 1 "$tr_airplane_options" "$icon_airplane" "" "$status_text")

    if [[ "$choice" == *"$tr_full_airplane"* ]]; then
        if $any_on; then
            show_loading_notification "$icon_airplane_on $tr_disabling_radios"
            timeout 5 nmcli radio wifi off 2>/dev/null
            timeout 5 nmcli radio wwan off 2>/dev/null
            if command -v bluetoothctl &> /dev/null; then timeout 5 bluetoothctl power off &>/dev/null; fi
            kill_loading_notification
            display_info_message "$tr_airplane_on" "$tr_airplane_mode_message" "$icon_airplane_on"
        else
            show_loading_notification "$icon_airplane_off $tr_enabling_radios"
            timeout 5 nmcli radio wifi on 2>/dev/null
            timeout 5 nmcli radio wwan on 2>/dev/null
            if command -v bluetoothctl &> /dev/null; then timeout 5 bluetoothctl power on &>/dev/null; fi
            kill_loading_notification
            display_info_message "$tr_airplane_off" "$tr_airplane_mode_message" "$icon_airplane_off"
        fi

    elif [[ "$choice" == *"$tr_enable_wifi"* ]] || [[ "$choice" == *"$tr_disable_wifi_only"* ]]; then
        if $wifi_on; then
            show_loading_notification "$icon_wifi_disable $tr_disabling_wifi"
            timeout 5 nmcli radio wifi off 2>/dev/null
            kill_loading_notification
            display_info_message "$tr_wifi_turned_off" "$tr_airplane_mode_message" "$icon_wifi_disable"
        else
            show_loading_notification "$icon_wifi_enable $tr_enabling_wifi"
            timeout 5 nmcli radio wifi on 2>/dev/null
            kill_loading_notification
            display_info_message "$tr_wifi_turned_on" "$tr_airplane_mode_message" "$icon_wifi_enable"
        fi
    fi
}
