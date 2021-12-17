# Nix Starter Config

This is a minimal (yet complete) nix flake for getting started with NixOS + home-manager.

## What this provides

- NixOS configuration on `configuration.nix`, accessible via `nixos-rebuild --flake`
- Home-manager configuration on `home.nix`, accessible via `home-manager --flake`
- Basic boilerplate for adding custom packages (under `pkgs`) and overlays (on `overlays.nix`). Acessible on your system, home config, as well as `nix build .#package-name`
- Dev shell for bootstrapping, accessible via `nix develop`

## How to get started

Assuming you have a basic NixOS installation up and running:

### Getting the repo
- [Install git](https://nixos.wiki/wiki/git)
- Clone this repo to somewhere acessible (i usually have a `/dotfiles` folder for this)
- Add stuff you currently have on `/etc/nixos/configuration.nix` to `configuration.nix`, and `/etc/nixos/hardware-configuration.nix` to `hardware-configuration.nix`
- If you're already using home-manager, add your stuff from `~/.config/nixpkgs/home.nix` to `home.nix`
- Take a look at `flake.nix`, filling out stuff marked by `TODO`s
- Create a remote repo (github, gitlab, sr.ht, etc) and push your changes for safekeeping

### Bootstrapping
- Run `nix develop --experimental-features "nix-command flakes"` to bootstrap into flake-enabled nix and home-manager.
- Run `sudo nixos-rebuild switch --flake .` to apply system configuration
- Run `home-manager switch --flake .` to apply home configuration
- Reboot!
