# Nix Starter Config (Minimal version)

This is a simple nix flake for getting started with NixOS + home-manager.

[**Looking for the full version?**](https://github.com/Misterio77/nix-starter-config/tree/main)

# What this provides

- NixOS configuration on `nixos/configuration.nix`, accessible via
  `nixos-rebuild --flake .`
- Home-manager configuration on `home-manager/home.nix`, accessible via
  `home-manager --flake .`

# Getting started

Assuming you have a basic NixOS booted up (either live or installed, anything
works). [Here's a link to the latest NixOS downloads, just for
you](https://nixos.org/download#download-nixos).

## The repo

- [Install git](https://nixos.wiki/wiki/git)
- [Hit "Use this
  template"](https://github.com/Misterio77/nix-starter-config/generate) on this
  repo (or clone this down and push to any another git remote)

- Add stuff you currently have on `/etc/nixos/` to `nixos` (usually
  `configuration.nix` and `hardware-configuration.nix`, when you're starting
  out).
    - The included file has some options you might want, specially if you don't
      have a configuration ready. Make sure you have generated your own
      `hardware-configuration.nix`; if not, just mount your partitions to
      `/mnt` and run: `nixos-generate-config --root /mnt`.
- If you're already using home-manager, add your stuff from `~/.config/nixpkgs`
  to `home-manager` (probably `home.nix`).
  - I also include one with some simple options if you need. Feel free to
    ignore this step if you don't want to use home-manager just yet.
- Take a look at `flake.nix`, making sure to fill out anything marked with
  FIXME (required) or TODO (usually tips or optional stuff you might want)
- Push your changes! Or at least copy them somewhere if you're on a live
  medium.

## Bootstrapping

To get everything up and running, you need flake-enabled nix and/or home-manager.

For simplicity, this minimal version does not include a bootstrap shell.

Check the [NixOS wiki](https://nixos.wiki/wiki/Flakes) for information on how to enable flakes.

## Usage

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
    - If you're still on a live installation medium, run `nixos-install --flake
      .#hostname` instead, and reboot.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.

# What next?

## Full version

Once you're confortable with this flake, take a look at the [full
version](https://github.com/Misterio77/nix-starter-config/tree/main), it includes
boilerplate for overlays, custom packages, and more.
