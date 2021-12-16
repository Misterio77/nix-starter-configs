{
  description = "You new nix config";

  inputs = {
    # Utilities for building flakes
    utils.url = "github:numtide/flake-utils";

    # Core nix flakes
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager flake
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Extra community flakes
    # Add any cool flakes you need
    # nur.url = "github:nix-community/NUR"; # User contributed pkgs and modules
    # impermanence.url = "github:riscadoa/impermanence"; # Utilities for opt-in persistance
    # nix-colors.url = "github:misterio77/nix-colors"; # Color schemes for usage with home-manager
  };

  outputs = { self, nixpkgs, home-manager, utils, ... }@inputs: {
    # Overlayed packages
    overlay = (import ./overlays.nix);

    # This repo's overlay plus any other overlays you use
    # If you want to use packages from flakes that are not nixpkgs, add their overlays here.
    overlays = [ self.overlay nur.overlay ];

    # System configurations
    # Accessible via 'nixos-rebuild --flake'
    nixosConfigurations = {
      cool-computer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          { nixpkgs.overlays = self.overlays; }
        ];
      };
    };

    # Home configurations
    # Accessible via 'home-manager --flake'
    homeConfigurations = {
      "you@cool-computer" = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        username = "you";
        homeDirectory = "/home/you";
        configuration = ./home.nix;
        extraModules = [{ nixpkgs.overlays = self.overlays; }];
      };
    };
  }
  // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = self.overlays; };
      hm = home-manager.defaultPackage."${system}";
    in
    {
      # Your custom packages, plus nixpkgs and overlayed stuff
      # Accessible via 'nix build .#example' or 'nix build .#nixpkgs.example'
      packages = {
        nixpkgs = pkgs;
      } // (import ./pkgs { inherit pkgs; });

      # Devshell for bootstrapping plus editor utilities (fmt and LSP)
      # Accessible via 'nix develop'
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ nix nixfmt rnix-lsp hm ];
      };
    });
}
