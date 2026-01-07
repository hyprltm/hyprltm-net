<h1 align="center">
  <img src="hyprltm-net.svg" width="80" alt="HyprLTM-Net Logo"/>
  <br>
  HyprLTM-Net
</h1>

<p align="center">
  <strong>A high-performance network management interface for Hyprland, powered by Rofi and NetworkManager.</strong>
</p>

<p align="center">
  <a href="https://github.com/hyprltm/hyprltm-net/stargazers"><img alt="GitHub Stars" src="https://img.shields.io/github/stars/hyprltm/hyprltm-net?style=for-the-badge&color=bd93f9&labelColor=282a36"/></a>
  <a href="https://github.com/hyprltm/hyprltm-net/commits/main"><img alt="Last Commit" src="https://img.shields.io/github/last-commit/hyprltm/hyprltm-net?style=for-the-badge&color=50fa7b&labelColor=282a36"/></a>
  <a href="https://github.com/hyprltm/hyprltm-net/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/hyprltm/hyprltm-net?style=for-the-badge&color=ff79c6&labelColor=282a36"/></a>
  <a href="https://github.com/hyprltm/hyprltm-net"><img alt="Repo Size" src="https://img.shields.io/github/repo-size/hyprltm/hyprltm-net?style=for-the-badge&color=8be9fd&labelColor=282a36"/></a>
</p>

https://github.com/user-attachments/assets/7da1d5b8-d8a1-47f4-8809-e82efc078ab2

<p align="center"><em>HyprLTM-Net Demo</em></p>

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 📶 Wi-Fi Management
- Scan for nearby networks
- Connect to new or hidden SSIDs
- Manage saved connections & passwords

### 🔌 Wired Profiles
- Switch between Ethernet configurations
- View connection status

</td>
<td width="50%">

### 🔐 VPN Support
- **WireGuard** & **OpenVPN** integration
- Import `.conf` or `.ovpn` files directly

### ⚙️ Advanced Controls
- **Airplane Mode** toggle
- **QR Code Sharing** for Wi-Fi
- **Hotspot** creation

</td>
</tr>
<tr>
<td colspan="2">

### 📦 Smart Installation
- **Distro Detection**: Auto-installs dependencies (Arch, Fedora, openSUSE, NixOS)
- **Desktop Entry**: Creates launcher menu entry & icon

</td>
</tr>
</table>

---

## 🛠️ Prerequisites

| Package | Purpose |
| :--- | :--- |
| `networkmanager` | Backend connection management (`nmcli`) |
| `rofi-wayland` | The graphical menu engine |
| `qrencode` | Generating Wi-Fi QR codes |
| `Nerd Fonts` | Required for icons (e.g., *JetBrains Mono Nerd Font*) |
| `imv` or `feh` | *(Optional)* Displaying QR codes |
| `libnotify` | *(Optional)* Desktop notifications |

---

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/hyprltm/hyprltm-net.git
cd hyprltm-net
```

### 2. Run the Installer
The install script will **detect your distribution** and offer to install missing dependencies.

It then provides **three interactive options**:
1.  **Desktop Entry** – Auto-creates a launcher menu entry & icon.
2.  **Keybind Setup** – Shows instructions to add a Hyprland keybind.
3.  **Waybar Setup** – Shows instructions to configure Waybar.

```bash
chmod +x install.sh
./install.sh
```

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

---

## 🎨 Theming

HyprLTM-Net uses the **LTMNight** color palette. Customize appearance by editing `~/.config/rofi/themes/ltmnight.rasi`.

| Variable | Description | Default |
| :--- | :--- | :--- |
| `@ltmnight9` | Primary Accent (Purple) | `#bd93f9` |
| `@ltmnight0` | Background | `#282a36` |
| `@ltmnight2` | Foreground | `#f8f8f2` |
| `@ltmnight7` | Success (Green) | `#50fa7b` |

---

## ☕ Support the Project

If you find this tool helpful, consider supporting its development!

<a href="https://www.buymeacoffee.com/linuxtechmore" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" >
</a>

---

## 📄 License

**Created by [Djalel Oukid (sniper1720)](https://github.com/sniper1720)** and distributed under the **GPL-3.0 License**.

<p align="center">
  <a href="https://www.linuxtechmore.com">🌐 LinuxTechMore.com</a>
</p>
