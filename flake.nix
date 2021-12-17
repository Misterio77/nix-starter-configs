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
    overlay = (import ./overlays);

    # This repo's overlay plus any other overlays you use
    # If you want to use packages from flakes that are not nixpkgs (such as NUR), add their overlays here.
    overlays = [
      self.overlay
      # nur.overlay
    ];

    # System configurations
    # Accessible via 'nixos-rebuild --flake'
    nixosConfigurations = {
      # TODO: Replace with your hostname
      cool-computer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
          # Adds your overlay and packages to nixpkgs
          { nixpkgs.overlays = self.overlays; }
          # Adds your custom nixos modules
          ./modules/nixos
        ];
        # Pass our flake inputs into the config
        specialArgs = { inherit inputs; };
      };
    };

    # Home configurations
    # Accessible via 'home-manager --flake'
    homeConfigurations = {
      # TODO: Replace with your username@hostname
      "you@cool-computer" = home-manager.lib.homeManagerConfiguration rec {
        # TODO: Replace with your username
        username = "you";
        homeDirectory = "/home/${username}";
        system = "x86_64-linux";

        configuration = ./home.nix;
        extraModules = [
          # Adds your overlay and packages to nixpkgs
          { nixpkgs.overlays = self.overlays; }
          # Adds your custom home-manager modules
          ./modules/home-manager
        ];
        # Pass our flake inputs into the config
        extraSpecialArgs = { inherit inputs; };
      };
    };
  }
  // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = self.overlays; };
      nix = pkgs.writeShellScriptBin "nix" ''
        exec ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      '';
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
