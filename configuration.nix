# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.

    # Import your generated hardware configuration
    ./hardware-configuration.nix

    # Feel free to split up your configuration and import pieces of it here.
  ];

  # TODO: Set your hostname
  networking.hostName = "cool-computer";

  # Comment out if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and 'nix' command
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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

  system.stateVersion = "22.05";
}
