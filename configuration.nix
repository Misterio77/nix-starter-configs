{ inputs, pkgs, ... }: {
  imports = [
    # Add external nixos modules here
    # inputs.hardware.nixosModules.common-cpu-amd
    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.11";
  # Uncomment to enable unfree packages for your system
  # nixpkgs.config.allowUnfree = true;

  # This will make all users source .nix-profile on login, activating home
  # manager automatically. Will allow you to use home-manager standalone on
  # setups with opt-in persistance.
  environment.loginShellInit = ''
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';
}
