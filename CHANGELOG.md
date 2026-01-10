# Changelog

All notable changes to this project will be documented in this file.

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

