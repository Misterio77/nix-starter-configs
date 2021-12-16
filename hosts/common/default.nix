# This file should hold stuff you use across all hosts
{ inputs, pkgs, ... }: {
  system.stateVersion = "21.11";
  # Uncomment to enable unfree packages for your systems. You can also put this
  # on the specific host
  # nixpkgs.config.allowUnfree = true;

  # This will make all users source .nix-profile on login, activating home
  # manager automatically. Will allow you to use home-manager standalone on
  # setups with opt-in persistance.
  environment.loginShellInit = ''
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';
}
