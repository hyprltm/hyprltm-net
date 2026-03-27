<h1 align="center">
  <img src="hyprltm-net.svg" width="80" alt="HyprLTM-Net Logo"/>
  <br>
  HyprLTM-Net
</h1>

<p align="center">
  <strong>A high-performance network management interface (GUI) for Hyprland, powered by Rofi and NetworkManager.</strong>
</p>

<p align="center">
  <img alt="Version" src="https://img.shields.io/badge/Version-v0.3.0-f1fa8c?style=for-the-badge&labelColor=282a36"/>
  <a href="https://github.com/hyprltm/hyprltm-net/stargazers"><img alt="GitHub Stars" src="https://img.shields.io/github/stars/hyprltm/hyprltm-net?style=for-the-badge&color=bd93f9&labelColor=282a36"/></a>
  <a href="https://github.com/hyprltm/hyprltm-net/commits/main"><img alt="Last Commit" src="https://img.shields.io/github/last-commit/hyprltm/hyprltm-net?style=for-the-badge&color=50fa7b&labelColor=282a36"/></a>
  <a href="https://github.com/hyprltm/hyprltm-net"><img alt="Repo Size" src="https://img.shields.io/github/repo-size/hyprltm/hyprltm-net?style=for-the-badge&color=8be9fd&labelColor=282a36"/></a>
</p>

[![HyprLTM-Net Demo](https://img.youtube.com/vi/k2QlRe5Cvls/maxresdefault.jpg)](https://youtu.be/k2QlRe5Cvls)

<p align="center"><em>HyprLTM-Net Demo (YouTube)</em></p>

![Gradient](assets/gradient.svg)

## Features

<table>
<tr>
<td width="50%" valign="top">

### Wi-Fi Management
- Scan for nearby networks
- Connect to new or hidden SSIDs
- Manage saved connections & passwords

<img src="assets/wifi_menu.png" width="100%" alt="Wi-Fi Menu"/>

</td>
<td width="50%" valign="top">

### Wired Profiles
- Switch between Ethernet configurations
- View connection status

<img src="assets/wired_menu.png" width="100%" alt="Wired Menu"/>

</td>
</tr>
<tr>
<td width="50%" valign="top">

### VPN Support
- **WireGuard** & **OpenVPN** integration
- Import `.conf` or `.ovpn` files directly

<img src="assets/vpn_menu.png" width="100%" alt="VPN Menu"/>

</td>
<td width="50%" valign="top">

### Advanced Controls
- **Airplane Mode** toggle
- **QR Code Sharing** for Wi-Fi
- **Hotspot Manager**

<img src="assets/hotspot_manager.png" width="100%" alt="Hotspot Manager"/>

</td>
</tr>
</table>

### Smart Installation
- **Distro Detection**: Auto-installs dependencies (Arch, Fedora, openSUSE, NixOS)
- **Desktop Entry**: Creates launcher menu entry & icon

### Robust Feedback
`hyprltm-net` includes a complete visual feedback system ensuring you never miss a status update.
- **Universal Semantic Styling**: Red (Error), Orange (Warning), Green (Success), and Blue (Info).
- **Blocking Dialogs**: Critical errors (e.g. Wrong Password) require user action to proceed.
- **Fallback Notification System**: If no notification service (like `dunst`) is running, the script automatically falls back to Rofi dialogs.

#### Feedback Gallery
<div align="center">
  <table width="80%">
    <tr>
      <td align="center">
        <img src="assets/error_dialog.png" width="100%"><br>
        <sub><b>Error (Red)</b>: Critical failures (like a wrong password or failed connection) trigger a blocking dialog. This ensures errors are never ignored silently.</sub>
      </td>
    </tr>
  </table>
  <br>
  <table width="80%">
    <tr>
      <td align="center">
        <img src="assets/warning_dialog.png" width="100%"><br>
        <sub><b>Warning (Orange)</b>: Alerts the user to important states, such as "No Notification Service found," suggesting a fallback to Rofi dialogs.</sub>
      </td>
    </tr>
  </table>
  <br>
  <table width="80%">
    <tr>
      <td align="center">
        <img src="assets/success_dialog.png" width="100%"><br>
        <sub><b>Success (Green)</b>: Immediate visual confirmation when a connection is successfully established.</sub>
      </td>
    </tr>
  </table>
  <br>
  <table width="80%">
    <tr>
      <td align="center">
        <img src="assets/info_dialog.png" width="100%"><br>
        <sub><b>Info (Blue)</b>: Contextual information, such as confirming that "Airplane Mode" has been enabled.</sub>
      </td>
    </tr>
  </table>
</div>

![Gradient](assets/gradient.svg)

## Menu Structure

```
Main Menu
├── Wi-Fi
│   ├── Status (Current Connection) -> View Details (IP, Signal, Mac...)
│   ├── Toggle (Enable / Disable)
│   ├── Available Networks (SSID List)
│   │   ├── [New Secure Network]
│   │   │   └── Enter Password
│   │   │       └── Password Actions (Show/Hide/Edit/Confirm)
│   │   └── [Saved Network]
│   │       ├── Autoconnect (Toggle)
│   │       ├── Connect / Disconnect Now
│   │       ├── IPv4 Configuration
│   │       ├── IPv6 Configuration
│   │       ├── Forget Connection
│   │       ├── Rename Connection
│   │       ├── Edit Password
│   │       └── Share via QR Code
│   ├── Hotspot Manager
│   │   ├── Create New Hotspot
│   │   └── Manage Saved Hotspots
│   │       └── [Hotspot Profile] -> (Toggle, Edit Password, Rename, Delete)
│   ├── Known Connections (Saved Profiles)
│   │   └── [Saved Wi-Fi Profile]
│   │       ├── Autoconnect (Toggle)
│   │       ├── Connect / Disconnect Now
│   │       ├── IPv4 Configuration
│   │       ├── IPv6 Configuration
│   │       ├── Forget Connection
│   │       ├── Rename Connection
│   │       ├── Edit Password
│   │       └── Share via QR Code
│   └── Connect to a hidden network
├── Wired
│   ├── [Available Interface] -> Connect
│   └── [Saved Profile] -> (Same options as Wi-Fi)
├── VPN
│   ├── [VPN Profile]
│   │   ├── Autoconnect (Toggle)
│   │   ├── Connect / Disconnect
│   │   ├── IPv4 / IPv6 Configuration
│   │   ├── Forget Connection
│   │   ├── Rename Connection
│   │   └── Edit Password (if applicable)
│   └── Import Configuration
├── Saved Connections
│   └── [List of All Profiles]
│       ├── Autoconnect (Toggle)
│       ├── Connect / Disconnect Now
│       ├── IPv4 Configuration
│       ├── IPv6 Configuration
│       ├── Forget Connection
│       ├── Rename Connection
│       ├── Edit Password
│       └── Share via QR Code
├── Status
│   ├── Active Connection Details (Popup)
│   └── All Device Status (List)
└── Airplane Mode (Toggle)
```

![Gradient](assets/gradient.svg)

## Prerequisites

| Package | Purpose |
| :--- | :--- |
| `networkmanager` | Backend connection management (`nmcli`) |
| `rofi-wayland` | The graphical menu engine |
| `qrencode` | Generating Wi-Fi QR codes |
| `dnsmasq` | Required for Hotspot creation (DHCP) |
| `Nerd Fonts` | Required for icons (e.g., *JetBrains Mono Nerd Font*) |
| `libnotify` | **(Optional)** For desktop notifications via `notify-send` |

![Gradient](assets/gradient.svg)

## Installation

### 1. One-Line Installation
```bash
bash <(curl -s https://raw.githubusercontent.com/hyprltm/hyprltm-net/main/setup.sh)
```
The script will auto-detect your distribution, install dependencies, and set up the menu.

<details>
<summary><strong>Manual Installation</strong></summary>

If you prefer to install manually:
```bash
mkdir -p ~/.local/bin && cp hyprltm-net.sh ~/.local/bin/hyprltm-net && chmod +x ~/.local/bin/hyprltm-net
mkdir -p ~/.config/rofi/themes/ && cp *.rasi ~/.config/rofi/themes/
```

**Keybind:** Add to `~/.config/hypr/hyprland.conf`:
```ini
bind = SUPER, N, exec, hyprltm-net
```

**Waybar:** Add to your `network` module in `~/.config/waybar/config.jsonc`:
```json
"on-click": "hyprltm-net"
```
</details>

![Gradient](assets/gradient.svg)

## Theming

HyprLTM-Net uses the **LTMNight** color palette. Customize appearance by editing `~/.config/rofi/themes/ltmnight.rasi`.

| Variable | Description | Default | Usage |
| :--- | :--- | :--- | :--- |
| `@ltmnight0` | Background | `#282a36` | Menu Background |
| `@ltmnight2` | Foreground | `#f8f8f2` | Main Text |
| `@ltmnight9` | Primary Accent | `#bd93f9` | List Selection |
| `@ltmnight4` | **Error** | `#ff5555` | 🟥 Error Dialogs |
| `@ltmnight5` | **Warning** | `#ffb86c` | 🟧 Warnings / Alerts |
| `@ltmnight7` | **Success** | `#50fa7b` | 🟩 Success Messages |
| `@ltmnight8` | **Info** | `#8be9fd` | 🟦 Info Dialogs |
| `@ltmnight3` | Comments | `#6272a4` | Borders / Outlines |

![Gradient](assets/gradient.svg)

## ❤️ Support the Project

If you find this tool helpful, there are many ways to support the project:

### Financial Support
If you'd like to support the development financially:

<a href="https://liberapay.com/sniper1720/"><img src="https://img.shields.io/badge/Liberapay-8be9fd?style=for-the-badge&logo=liberapay&logoColor=282a36&labelColor=8be9fd" height="36" /></a>
<a href="https://www.buymeacoffee.com/linuxtechmore"><img src="https://img.shields.io/badge/Fuel%20the%20next%20commit-f1fa8c?style=for-the-badge&logo=buy-me-a-coffee&logoColor=282a36" height="36" /></a>
<a href="https://github.com/sponsors/sniper1720"><img src="https://img.shields.io/badge/Become%20a%20Sponsor-bd93f9?style=for-the-badge&logo=github&logoColor=white" height="36" /></a>

### Contribute & Support
Financial contributions are not the only way to help! Here are other options:
- **Star the Repository**: It helps more people find the project!
- **Report Bugs**: Found an issue? Open a ticket on GitHub.
- **Suggest Features**: Have a cool idea? Let me know!
- **Share**: Tell your friends!

Every bit of support helps keep the project alive and ensures I can spend more time developing open source tools for the Linux community!

![Gradient](assets/gradient.svg)

## License

**Created by [Djalel Oukid (sniper1720)](https://github.com/sniper1720)** and distributed under the **GPL-3.0 License**.

*Check out more Linux & Open Source content on my [website!](https://www.linuxtechmore.com)*
