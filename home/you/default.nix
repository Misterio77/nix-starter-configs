{ inputs, pkgs, hostname, ... }: {
  imports = [
    # Split up your config into more files and import them here
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  # You can do stuff conditionally based on hostname, too:
  /*
  programs.alacritty = pkgs.lib.mkIf (hostname == "foo-bar") {
    enable = true;
  };
  */
}
