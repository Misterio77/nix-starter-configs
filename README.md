# Nix Starter Config

This is a minimal (yet complete) nix flake for getting started with NixOS + home-manager.

## What this provides

- NixOS configuration on `configuration.nix`, accessible via `nixos-rebuild --flake`
- Home-manager configuration on `home.nix`, accessible via `home-manager --flake`
- Basic boilerplate for adding custom packages (under `pkgs`) and overlays (under `overlays`). Acessible on your system, home config, as well as `nix build .#package-name`
- Boilerplate for custom NixOS (`modules/nixos`) and home-manager (`modules/home-manager`) modules
- Dev shell for bootstrapping, accessible via `nix develop`

## Getting started

Assuming you have a basic NixOS installation up and running:

### The repo
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

## How to's

### Customize your NixOS configuration

Use the `configuration.nix` file.

For a list of options, see `man configuration.nix`. Also see [the manual](https://nixos.org/manual/nixos/stable/index.html#ch-configuration).

### Customize your home-manager configuration

Use the `home.nix` file.

For a list of options, see `man home-configuration.nix`. Also see [the manual](https://rycee.gitlab.io/home-manager/index.html#ch-usage).


### Adding packages

Create a folder inside `pkgs`, and add a `default.nix` file containing a derivation. Be sure to also `callPackage` them on `pkgs/default.nix`.

See [the manual](https://nixos.org/manual/nixpkgs/stable/).

### Adding overlays

Use the `overlays/default.nix` file. If it gets too big, feel free to split it up.

If you're applying patches, i recommend you keep the patches on the `overlays` folder as well.

See [the wiki article](https://nixos.wiki/wiki/Overlays).

### Adding your own modules

Create a file for them on either `modules/nixos` or `modules/home-manager`. Be sure to also add them to the listing at `modules/nixos/default.nix` or `modules/home-manager/default.nix`.

See [the wiki article](https://nixos.wiki/wiki/Module).

### Adding more hosts or users, or multiple files

If you're starting to manage more than one host or user (or splitting up a big configuration in multiple files), you might want to create a `hosts` and/or `users` folder, and move your configs there. Be sure to change the path on `flake.nix` as well.
