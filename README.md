# Nix Starter Config

This is a simple nix flake for getting started with NixOS + home-manager.

# What this provides

- NixOS configuration on `nixos/configuration.nix`, accessible via
  `nixos-rebuild --flake .`
- Home-manager configuration on `home-manager/home.nix`, accessible via
  `home-manager --flake .`
- Basic boilerplate for adding custom packages (under `pkgs`) and overlays
  (under `overlays`). Accessible on your system, home config, as well as `nix
  build .#package-name`
- Boilerplate for custom NixOS (`modules/nixos`) and home-manager
  (`modules/home-manager`) modules

# Getting started

Assuming you have a basic NixOS booted up (either live or installed, anything
works). [Here's a link to the latest NixOS downloads, just for
you](https://nixos.org/download#download-nixos).

## I like you funny words, magic man

Not sure what this all means?

Take a look at [the learn hub on the NixOS
website](https://nixos.org/learn.html) (scroll down to guides, the manuals, and
the other awesome learning resources).

Learning the basics of what Nix (the package manager) is, how the Nix language
works, and a bit of NixOS basics should get you up and running. Don't worry if
it seems a little confusing at first. Get confortable with the basic concepts
and come back here to get your feet wet, it's the best way to learn!

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

To get everything up and running, you need flake-enabled nix and home-manager.

First off, check your nix version using `nix --version`.

### Version < 2.4

Bummer, your nix version does not support flakes. But fear not!

You _don't_ need to mess around with channels to get up and running.

Just run:
```bash
nix-shell
```

Wow, that was easy. Our `shell.nix` file will detect you can't evaluate (nor
lock) the flake, and will grab `nix` and `home-manager` from the latest
`nixos-unstable` versions, just for you.

Once you're bootstrapped, remember to run `nix flake lock` and commit the
newly-created `flake.lock` into your repository, this will make future
bootstraps reproductible.

### Version >= 2.4

Congrats, your nix version supports flakes! It's just hidden behind a feature flag.

You can bootstrap with: 
```bash
nix --experimental-features develop "nix-command flakes" .#default
```

The shell will also enable those experimental features, so no need to pass that
argument while you're inside (or after installation, if you set the option that
enables them globally).

This should generate a `flake.lock`. Remember to commit it, as this will make
future bootstraps reproductible.

## Usage

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
    - If you're still on a live installation medium, run `nixos-install --flake
      .#hostname` instead, and reboot.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.

# What next?

## User password and secrets

For people fresh from installation: Unless you used `--no-root-passwd`,
`nixos-install` prompted you for a root password. Use it to log into the root
account, set your own account's password imperatively with `passwd`, and
disable root login (`sudo passwd -l root`). You can also use `--no-root-passwd`
and instead set `initialPassword` for your user, for a temporary password upon
install.

If you don't want to set your password imperatively, you can also use
`passwordFile` for safely and declaratively setting a password from a file
outside the nix store.

There's also [more advanced options for secret
management](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes),
including some that can include them (encrypted) into your config repo and/or
nix store, be sure to check them out if you're interested.

## Dotfile management with home-manager

Besides just adding packages to your environment, home-manager can also manage
your dotfiles. I strongly recommend you do, it's awesome!

For full nix goodness, check out the home-manager options with `man
home-configuration.nix`. Using them, you'll be able to fully configure any
program with nix syntax and its powerful abstractions.

Alternatively, if you're still not ready to rewrite all your configs to nix
syntax, there's home-manager options (such as `xdg.configFile`) for including
files from your config repository into your usual dot directories. Add your
existing dotfiles to this repo and try it out!

## Try opt-in persistance

You might have noticed that there's impurity in your NixOS system, in the form
of configuration files and other cruft your system generates when running. What
if you change them in a whim to get something working and forget about it?
Boom, your system is not fully reproductible anymore.

You can instead fully delete your `/` and `/home` on every boot! Nix is okay
with a empty root on boot (all you need is `/boot` and `/nix`), and will
happily reapply your configurations.

There's two main approaches to this: mount a `tmpfs` (RAM disk) to `/`, or
(using a filesystem such as btrfs or zfs) mount a blank snapshot and reset it
on boot.

For stuff that can't be managed through nix (such as games downloaded from
steam, or logs), use [impermanence](https://github.com/nix-community/impermanence)
for mounting stuff you to keep to a separate partition/volume (such as
`/nix/persist` or `/persist`). This makes everything vanish by default, and you
can keep track of what you specifically asked to be kept.

Here's some awesome blog posts about it:
- [Erase your darlings](https://grahamc.com/blog/erase-your-darlings)
- [Encrypted BTRFS with Opt-In State on
  NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
- [NixOS: tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) and
  [tmpfs as home](https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/)

## Adding custom packages

Something you want to use that's not in nixpkgs yet? You can easily build and
iterate on a derivation (package) from this very repository.

Create a folder with the desired name inside `pkgs`, and add a `default.nix`
file containing a derivation. Be sure to also `callPackage` them on
`pkgs/default.nix`.

You'll be able to refer to that package from anywhere on your
home-manager/nixos configurations, build them with `nix build .#package-name`,
or bring them into your shell with `nix shell .#package-name`.

See [the manual](https://nixos.org/manual/nixpkgs/stable/) for some tips on how
to package stuff.

## Adding overlays

Found some outdated package on nixpkgs you need the latest version of? Perhaps
you want to apply a patch to fix a behaviour you don't like? Nix makes it easy
and manageble with overlays!

Use the `overlay/default.nix` file for this.

If you're creating patches, you can keep them on the `overlay` folder as well.

See [the wiki article](https://nixos.wiki/wiki/Overlays) to see how it all
works.

## Adding your own modules

Got some configurations you want to create an abstraction of? Modules are the
answer. These awesome files can expose _options_ and implement _configurations_
based on how the options are set.

Create a file for them on either `modules/nixos` or `modules/home-manager`. Be
sure to also add them to the listing at `modules/nixos/default.nix` or
`modules/home-manager/default.nix`.

See [the wiki article](https://nixos.wiki/wiki/Module) to learn more about
them.

## Adding more hosts or users

You can organize them by hostname and username on `nixos` and `home-manager`
directories, be sure to also add them to `flake.nix`.

NixOS makes it easy to share common configuration between hosts (you might want
to create a common directory for these), while keeping everything in sync.
home-manager can help you sync your environment (from editor to WM and
everything in between) anywhere you use it. Have fun!
