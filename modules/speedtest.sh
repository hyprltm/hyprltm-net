# =============================================================================
#                            SPEEDTEST MODULE
# =============================================================================

run_speedtest() {
    if ! command -v curl &> /dev/null; then
        show_error_message "$tr_speedtest_no_curl"
        return
    fi

    if ! command -v ping &> /dev/null; then
        show_error_message "$tr_speedtest_no_ping"
        return
    fi

    show_loading_notification "$tr_speedtest_running"

    local dl_rate=$(curl -s -w "%{speed_download}" -o /dev/null "https://speed.cloudflare.com/__down?bytes=10000000" 2>/dev/null)

    local up_test_file="$TEMP_DIR/up_test.dat"
    dd if=/dev/zero of="$up_test_file" bs=1M count=10 &>/dev/null
    local ul_rate=$(curl -s -w "%{speed_upload}" -o /dev/null -X POST --data-binary @"$up_test_file" "https://speed.cloudflare.com/__up" 2>/dev/null)
    rm -f "$up_test_file"

    local dl_mbps=$(awk -v rate="$dl_rate" 'BEGIN { printf "%.2f", rate / 125000 }')
    local ul_mbps=$(awk -v rate="$ul_rate" 'BEGIN { printf "%.2f", rate / 125000 }')

    local ping_target="${SPEEDTEST_PING_HOST:-1.1.1.1}"
    local ping_result=$(ping -c 4 -W 2 "$ping_target" 2>/dev/null | awk -F'/' '/rtt/ { printf "%.1f", $5 }')

    kill_loading_notification

    if [ -z "$dl_rate" ] || [ "$dl_rate" = "0.000" ] || [ "$dl_rate" = "0" ]; then
        show_error_message "$tr_speedtest_error"
        return
    fi

    local formatted_result="$icon_download  $dl_mbps Mbps  (Download)\n$icon_upload  $ul_mbps Mbps  (Upload)\n$icon_ping  ${ping_result:-?} ms  ($tr_ping)"
    display_info_message "$formatted_result" "$tr_speedtest_menu" "$icon_speedtest"
}

