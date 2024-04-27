# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}
