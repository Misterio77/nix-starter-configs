# NixOS Niri Workstation Configuration

NixOS config với **Niri compositor** + **Waybar**, module-based architecture.

## 🚀 Features

- **NixOS 25.11** + Niri scrollable-tiling compositor
- **Waybar** - Status bar cho Wayland
- **Modular** - Easy enable/disable với `workstation.niri.enable`
- **Theme** - Tokyonight + Rose Pine cursor
- **Dev Ready** - Docker, PostgreSQL, Nginx

---

## ✅ Quick Checklist (Clone về máy mới)

- [ ] Clone repo
- [ ] Copy hardware-configuration.nix từ `/etc/nixos/`
- [ ] Đổi hostname trong 2 file: `configuration.nix`, `flake.nix`
- [ ] Đổi username trong 4 file: `configuration.nix`, `home.nix`, `flake.nix`, `niri-workstation.nix`
- [ ] Đổi git name/email trong `home.nix`
- [ ] Chạy `./test-build.sh` để test
- [ ] Nếu OK, chạy `nix flake update` và rebuild
- [ ] Logout, chọn "niri-session"

---

## 📥 Clone về máy hiện tại

### Bước 1: Clone repo
```bash
# Clone về thư mục tạm
cd ~
git clone https://github.com/YOUR_USERNAME/nix-starter-configs.git
cd nix-starter-configs/standard
```

### Bước 2: Thay thế hardware config
```bash
# Backup hardware config hiện tại
sudo cp /etc/nixos/hardware-configuration.nix nixos/hardware-configuration.nix
```

### Bước 3: Sửa thông tin cá nhân

**File `nixos/configuration.nix`:**
```nix
# Đổi hostname
networking.hostName = "your-hostname";

# Đổi username
users.users = {
  your-username = {  # <-- Đổi tên user
    initialPassword = "your-password";
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
  };
};
```

**File `home-manager/home.nix`:**
```nix
home = {
  username = "your-username";  # <-- Đổi tên user
  homeDirectory = "/home/your-username";
};

programs.git = {
  userName = "Your Name";      # <-- Đổi tên
  userEmail = "your@email.com"; # <-- Đổi email
};
```

**File `flake.nix`:**
```nix
# Dòng 56: Đổi hostname
nixosConfigurations = {
  your-hostname = nixpkgs.lib.nixosSystem {  # <-- Đổi hostname
    # ...
  };
};

# Dòng 67: Đổi username@hostname
homeConfigurations = {
  "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
    # ...
  };
};
```

**File `modules/nixos/niri-workstation.nix` (dòng 60):**
```nix
initial_session = {
  command = "niri-session";
  user = "your-username";  # <-- Đổi username
};
```

### Bước 4: Test build (QUAN TRỌNG!)
```bash
# Dùng script helper
./test-build.sh

# Hoặc test thủ công:
# Test build NixOS (không apply)
sudo nixos-rebuild build --flake .#your-hostname

# Test build home-manager (không apply)
home-manager build --flake .#your-username@your-hostname

# Nếu không có lỗi, tiếp tục bước 5
```

### Bước 5: Apply configuration
```bash
# Update flake lock
nix flake update

# Apply system config
sudo nixos-rebuild switch --flake .#your-hostname

# Apply home-manager config
home-manager switch --flake .#your-username@your-hostname
```

### Bước 6: Logout và login
Chọn "niri-session" trong GrETD login screen.

---

## ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + D` | App launcher |
| `Super + Q` | Close window |
| `Super + Arrow Keys` | Navigate |
| `Super + 1/2/3/4` | Switch workspace |
| `Super + Scroll` | Scroll workspaces |
| `Print` | Screenshot |

---

## 🏗️ Cấu trúc

```
standard/
├── flake.nix                    # Flake config với Niri inputs
├── nixos/
│   ├── configuration.nix        # System config
│   └── hardware-configuration.nix
├── home-manager/
│   └── home.nix                 # User config
└── modules/
    ├── nixos/
    │   └── niri-workstation.nix # Module: workstation.niri
    └── home-manager/
        └── gtk-theme.nix        # Module: GTK theme
```

---

## 🎯 Module System

### Enable/Disable Niri Workstation
```nix
# Trong nixos/configuration.nix
workstation.niri.enable = true;  # hoặc false
```

**Bao gồm:**
- Niri compositor + Waybar status bar
- GrETD display manager
- Yazi file manager
- Fuzzel launcher
- Screenshot tools
- All utilities

---

## 📦 Packages

**System:**
- Docker, PostgreSQL, Nginx
- Niri compositor + Waybar + Xwayland-satellite
- Wayland utilities

**User:**
- Firefox, Discord, Spotify
- Neovim, Git, Alacritty
- Fuzzel, Mako

---

## 🔧 Customization

### Thêm package hệ thống
Edit `modules/nixos/niri-workstation.nix`:
```nix
environment.systemPackages = with pkgs; [
  # existing...
  your-package
];
```

### Thêm package user
Edit `home-manager/home.nix`:
```nix
home.packages = with pkgs; [
  # existing...
  your-package
];
```

---

## 🆘 Troubleshooting

### Build fail?
```bash
# Check syntax
nix flake check

# Check logs
nixos-rebuild build --flake .#your-hostname --show-trace
```

### Theme không apply?
```bash
rm -rf ~/.cache/gtk-*
home-manager switch --flake .#your-username@your-hostname
```

---

## 📝 Notes

- **NixOS Version:** 25.11
- **Theme:** Tokyonight-Dark + Rose Pine cursor
- **Status Bar:** Waybar (auto-start, config included)
- **Auto-login:** Enabled via GrETD
- **Waybar config:** `waybar-config.json` được copy vào `~/.config/waybar/config`

---

## 🔗 Links

- [Niri](https://github.com/YaLTeR/niri) | [Niri Flake](https://github.com/sodiboo/niri-flake)
- [Waybar](https://github.com/Alexays/Waybar) - Status bar
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)

**Enjoy! 🎉**
