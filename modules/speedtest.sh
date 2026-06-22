# =============================================================================
#                            SPEEDTEST MODULE
# =============================================================================

run_speedtest() {
    show_loading_notification "$tr_speedtest_running"

    local dl_rate=$(curl -s -w "%{speed_download}" -o /dev/null "https://speed.cloudflare.com/__down?bytes=10000000" 2>/dev/null)

    dd if=/dev/zero of=/tmp/hlnet_up_test.dat bs=1M count=10 &>/dev/null
    local ul_rate=$(curl -s -w "%{speed_upload}" -o /dev/null -X POST --data-binary @/tmp/hlnet_up_test.dat "https://speed.cloudflare.com/__up" 2>/dev/null)
    rm -f /tmp/hlnet_up_test.dat

    local dl_mbps=$(awk -v rate="$dl_rate" 'BEGIN { printf "%.2f", rate / 125000 }')
    local ul_mbps=$(awk -v rate="$ul_rate" 'BEGIN { printf "%.2f", rate / 125000 }')

    local ping_result=$(ping -c 4 -W 2 1.1.1.1 2>/dev/null | awk -F'/' '/rtt/ { printf "%.1f", $5 }')

    kill_loading_notification

    if [ -z "$dl_rate" ] || [ "$dl_rate" = "0.000" ] || [ "$dl_rate" = "0" ]; then
        show_error_message "$tr_speedtest_error"
        return
    fi

    local formatted_result="$icon_download  $dl_mbps Mbps  (Download)\n$icon_upload  $ul_mbps Mbps  (Upload)\n$icon_ping  ${ping_result:-?} ms  ($tr_ping)"
    display_info_message "$formatted_result" "$tr_speedtest_menu" "$icon_speedtest"
}

