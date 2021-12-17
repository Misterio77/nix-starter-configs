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

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;

  # TODO: Configure your users as usual.
  users.users = {
    you = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Add your SSH public key(s) here.
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDci4wJghnRRSqQuX1z2xeaUR+p/muKzac0jw0mgpXE2T/3iVlMJJ3UXJ+tIbySP6ezt0GVmzejNOvUarPAm0tOcW6W0Ejys2Tj+HBRU19rcnUtf4vsKk8r5PW5MnwS8DqZonP5eEbhW2OrX5ZsVyDT+Bqrf39p3kOyWYLXT2wA7y928g8FcXOZjwjTaWGWtA+BxAvbJgXhU9cl/y45kF69rfmc3uOQmeXpKNyOlTk6ipSrOfJkcHgNFFeLnxhJ7rYxpoXnxbObGhaNqn7gc5mt+ek+fwFzZ8j6QSKFsPr0NzwTFG80IbyiyrnC/MeRNh7SQFPAESIEP8LK3PoNx2l1M+MjCQXsb4oIG2oYYMRa2yx8qZ3npUOzMYOkJFY1uI/UEE/j/PlQSzMHfpmWus4o2sijfr8OmVPGeoU/UnVPyINqHhyAd1d3Iji3y3LMVemHtp5wVcuswABC7IRVVKZYrMCXMiycY5n00ch6XTaXBwCY00y8B3Mzkd7Ofq98YHc= (none)"
      ];
    };
  };

  # This setups SSH for the system (with SSH keys ONLY). Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  # Remove if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and new 'nix' command
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
}
