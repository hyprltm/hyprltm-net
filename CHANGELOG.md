# Changelog

All notable changes to this project will be documented in this file.

## [v0.3.0] - 2026-01-21

### Added
-   **Hotspot Manager**: New hierarchical menu with "Create New" and "Manage Saved" profiles.
-   **Tethering Support**: Added dedicated Bluetooth icon (`󰂯`) for tethering connections.
-   **Granular Control**: Option to Rename, Edit Password, Show QR, and Delete saved hotspot profiles.
-   **Robust Error Handling**: Connection failures (Wi-Fi, VPN, Wired) now trigger blocking Rofi dialogs with "Try Again" / "Edit Password" options, ensuring issues are never silent.
-   **One-Line Installer**: New `setup.sh` with bootstrap logic allows installing via a single `curl | bash` command without manual cloning.
-   **Universal Semantic Styling**: All Rofi dialogs now follow a strict color code:
    -   🟥 **Error**: Red border/text (Connection failed).
    -   🟧 **Warning**: Orange border/text.
    -   🟦 **Info**: Blue/Cyan border/text.
    -   🟩 **Success**: Green border/text.
-   **Fallback Feedback**: If no system notification daemon (e.g., `dunst`) is running, the script automatically falls back to showing a Green Rofi Success dialog.
-   **Explicit Notification Logic**: Refactored internal notification system to use explicit properties (`type="error"`) instead of fragile text parsing.
-   **Documentation Gallery**: Refactored README to include a detailed Vertical Feedback Gallery with descriptive captions.

### Changed
-   **UI Polish**: Replaced "Headphones" icon with "Bookmark Check" (`󰢭`) for saved items.
-   **Code Quality**: Replaced unsafe `\0` delimiters with `;;;` and cleaned code comments.
-   **Terminology**: Standardized documentation to use "Notification Service" instead of "Daemon".
-   **Info Dialogs**: Refactored informational messages (e.g., Airplane Mode status) to use a dedicated visual style (Blue Box) instead of generic lists.
-   **Airplane Mode**: Now uses specific icons for Enabled (󱡻) and Disabled (󱢂) states.
-   **Error Messages**: Added specific detection for "Network not found" (Router down/out of range) to distinguish it from generic "Refused" errors.
-   **Dialog Layout**: Refined Error/Warning dialogs to remove unused input bars and prompts for a cleaner look.
-   **UI Consistency**: Ensured 1px borders and consistent iconography across all message types.
-   **Icons**: Fixed missing icons in Error dialogs and added distinct icons for "Network not found" (󰐷).
-   **Hotspot Manager**: Full-featured menu with **Multi-profile support**. Manage multiple saved hotspots (Toggle, Edit, Rename, QR, Delete) from a dedicated sub-menu.
-   **Status Clarity**: Main Wi-Fi menu now explicitly says "Hotspot Active" instead of "Connected to" when running an Access Point.
-   **Hotspot Logic**: Completely rewrote creation logic (WPA2/2.4GHz), added "Disconnect Safety Check", and made `dnsmasq` a required dependency.

### Fixed
-   **Loopback**: Filtered out useless `lo` connections from the saved list.
-   **Hotspot Selection**: Fixed bug where selecting a saved hotspot caused a menu loop (implemented Index Matching).
-   **Hotspot Safety**: Fixed critical conflict where stopping one hotspot would auto-enable another (Added `autoconnect=no`).
-   **Safe Disconnect**: Fixed detection logic (`grep :802-11-wireless`) so the "Wi-Fi Disconnect Warning" correctly appears before creating a hotspot.
-   **UI Formatting**: Fixed issue where newlines in dialog messages were rendered as literal `\n` text.
-   **Dialog Polish**: Changed confirmation button from generic "Continue" to "Proceed" for clearer warnings.
-   **VPN Autoconnect**: Fixed critical issue where imported VPNs would auto-connect on boot/restart. New imports now default to `autoconnect=no`.
-   **Logic**: Fixed "Edit Password" incorrectly reporting "Successfully Connected" without attempting connection. Now correctly says "Password Updated".
-   **Silent Failures**: Fixed bug where cancelling a connection or failing a VPN import would fail silently or show a confusing Green success message.
-   **False Positives**: Resolved issue where "Failed to connect" messages were styled as Success (Green).
---

## [v0.2.1] - 2026-01-11

### Fixed
-   **VPN Menu**: Fixed parsing issue where null delimiters (`\0`) caused VPN entries to be mishandled by `awk`.

## [v0.2.0] - 2026-01-10


### Added
-   **In-Rofi QR Code Display**: Wi-Fi QR codes now appear directly inside the Rofi window as a large icon, eliminating the need for external image viewers.
-   **Airplane Mode**: New toggle in the main menu to disable/enable all networking radios.
-   **Hotspot Creation**: Ability to create a Wi-Fi hotspot directly from the menu.
-   **System Notifications**: Added optional support for `notify-send` for connection status updates.
-   **Password Management**: New "Edit Password" option and Smart Recovery prompt when connections fail due to authentication errors.
-   **Connection Details View**: Click on the "Connected to [SSID]" status line to view IP, Gateway, Link Speed, Frequency, and MAC details.
-   **Documentation**: Added a Menu Structure tree to the README.

### Changed
-   **Menu Layout**: moved DNS configuration inside the IPv4/IPv6 submenus for a cleaner interface.
-   **UI Prompts**: improved IP configuration prompts to explicitly state "IPv4" or "IPv6".
-   **Dependencies**: Removed `imv` and `feh`. Clarified `Nerd Fonts` as required. Added `libnotify` as optional.
-   **Badges**: Updated "New" badges to use LTMNight palette colors.
-   **Installation**: Updated `install.sh` to reflect dependency changes.
-   **Refinements**:
    -   **Clean Scan List**: Reduced icon clutter for a cleaner look.
    -   **Iconography**: Standardized to `[Signal] [Status] SSID` layout. Updated Secure () and Hotspot (󱄙) icons.
    -   **Smart Connection Menu**: Now offers "Disconnect" if you are already connected to that network.

### Fixed
-   **Saved Networks**: Fixed issue where selecting a saved network would wrongly ask for a password.
-   **Scanning**: Fixed issue where sometimes only the connected network was visible.
-   **Active Selection**: Fixed bug where selecting the currently active network (marked with ) showed an error or blinked. It now instantly opens the menu.
-   **Crashes**: Resolved specific `nmcli` and syntax errors.

