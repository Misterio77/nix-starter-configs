{
  description = "You new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      # Bring some functions into scope (from builtins and other flakes)
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
    in
    rec {
      # System configurations
      # Accessible via 'nixos-rebuild'
      nixosConfigurations = {
        # FIXME: Replace with your hostname
        your-hostname = nixosSystem {
          system = "x86_64-linux";
          # >> Main NixOS configuration file <<
          modules = [ ./nixos/configuration.nix ];
          # Make our inputs available to the config (for importing modules)
          specialArgs = { inherit inputs; };
        };
      };

      # Home configurations
      # Accessible via 'home-manager'
      homeConfigurations = {
        # FIXME: Replace with your username@hostname
        "your-name@your-hostname" = homeManagerConfiguration rec {
          # FIXME: Replace with your username
          username = "your-name";
          homeDirectory = "/home/${username}";
          system = "x86_64-linux";
          # >> Main home-manager configuration file <<
          configuration = ./home-manager/home.nix;
          # Make our inputs available to the config (for importing modules)
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
