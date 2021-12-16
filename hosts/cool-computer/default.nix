{ inputs, pkgs, ... }: {
  imports = [
    ../common
    # You can split your config up and import other files here
    # You should also take a look at nixos-hardware and import and needed modules, such as:
    # inputs.hardware.nixosModules.common-cpu-amd
    ./hardware-configuration.nix
  ];
}
