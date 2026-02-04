# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    inputs.self.homeManagerModules.gtk-theme

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # Niri home-manager module
    inputs.niri.homeModules.niri

    # Catppuccin theme module
    inputs.catppuccin.homeManagerModules.catppuccin

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "river";
    homeDirectory = "/home/river";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Font configuration
  fonts.fontconfig.enable = true;

  # Catppuccin theme configuration
  catppuccin = {
    enable = true;
    flavor = "mocha";  # Options: latte, frappe, macchiato, mocha
    accent = "mauve";  # Options: blue, flamingo, green, lavender, maroon, mauve, peach, pink, red, rosewater, sapphire, sky, teal, yellow
  };

  # Dotfiles & config
  programs.git = {
    enable = true;
    userName = "thanghv15";
    userEmail = "thanghv15@vingroup.net";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font = {
        normal.family = "Lilex Nerd Font Mono";
        size = 13.0;
      };
    };
  };

  # User-specific packages
  home.packages = with pkgs; [
    firefox
    discord
    spotify
    # Niri utilities
    fuzzel  # Application launcher for Wayland
    mako    # Notification daemon for Wayland
    # waybar removed - Noctalia provides its own bar
    swaylock # Screen locker
    grim     # Screenshot utility
    slurp    # Region selector for screenshots
    # Fonts
    (nerdfonts.override { fonts = [ "Lilex" ]; })
  ] ++ [
    # Noctalia shell from flake input
    inputs.noctalia.packages.${pkgs.system}.default
  ];

  # Niri configuration
  programs.niri = {
    enable = true;
    settings = {
      input = {
        keyboard.xkb = {
          layout = "us";
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
      };

      layout = {
        gaps = 8;
        border.width = 2;
      };

      # Spawn Noctalia shell at startup
      spawn-at-startup = [
        { command = ["noctalia"]; }
        { command = ["mako"]; }  # Notification daemon
      ];

      binds = {
        # Basic binds
        "Mod+Return".action.spawn = ["alacritty"];
        "Mod+D".action.spawn = ["fuzzel"];
        "Mod+Q".action.close-window = {};

        # Movement
        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Down".action.focus-window-down = {};

        # Workspaces
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;

        # Move to workspace
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;

        # Screenshot
        "Print".action.spawn = ["grim" "-g" "$(slurp)"];
      };
    };
  };

  # Shell config
  programs.bash.enable = true;
  programs.starship.enable = true;

  # Files trong ~
  home.file.".bashrc".text = ''
    # Custom bash configuration
    export EDITOR=hx
    alias ll='ls -lah'
    alias gs='git status'

    # Starship prompt
    eval "$(starship init bash)"
  '';

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
