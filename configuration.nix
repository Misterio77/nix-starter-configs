# This is your system's configuration file.

{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    # It's extremely recommended you take a look at https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware (the above examples are for AMD CPUs and SSDs).

    # Import your generated hardware configuration
    ./hardware-configuration.nix

    # Feel free to split up your configuration and import pieces of it here.
  ];

  # Set your hostname
  networking.hostName = "cool-computer";

  # Comment out to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  # This will make all users source .nix-profile on login, activating home
  # manager automatically. Will allow you to use home-manager standalone on
  # setups with opt-in persistance.
  environment.loginShellInit = ''
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';

  # This will add your inputs as registries, making operations with them
  # consistent with your flake inputs.
  nix.registry = lib.mapAttrs' (n: v:
    lib.nameValuePair ("${n}") ({ flake = inputs."${n}"; })
  ) inputs;

  system.stateVersion = "21.11";
}
