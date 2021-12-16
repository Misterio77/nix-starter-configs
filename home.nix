{ inputs, pkgs, hostname, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.nixosModule

    # Feel free to split up your configuration and import pieces of it here.
  ];

  # Comment out to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.users.startServices = "sd-switch";
}
