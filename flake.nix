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

    # Other community flakes
    # Add any other flakes you need
    nur.url = "github:nix-community/NUR";
    impermanence.url = "github:riscadoa/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, hardware, home-manager, nur, impermanence, nix-colors, utils }@inputs:
    let
      # Utility for building a system configuration
      mkSystem = { hostname, system }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Host configuration
            (./hosts + "/${hostname}")
            # Your custom modules
            ./modules/nixos
            # Common stuff
            {
              # Add hostname
              networking.hostName = hostname;
              # Add your overlays to system config
              nixpkgs.overlays = self.overlays;
              # Add your flake inputs to system registry
              nix.registry = nixpkgs.lib.mapAttrs'
                (n: v:
                  nixpkgs.lib.nameValuePair ("${n}") ({ flake = inputs."${n}"; })
                )
                inputs;
            }
          ];
        };

      # Utility for building a home configuration
      mkHome = { username, hostname, system }:
        home-manager.lib.homeManagerConfiguration {
          inherit username system;
          extraSpecialArgs = { inherit hostname inputs; };
          homeDirectory = "/home/${username}";
          configuration = ./home + "/${username}";
          extraModules = [
            # Your custom modules
            ./modules/home-manager
            # Common stuff
            {
              # Add your overlays to home config
              nixpkgs.overlays = self.overlays;
              # Enable home-manager and git, needed for basic usage
              programs = {
                home-manager.enable = true;
                git.enable = true;
              };
              # Update services as needed
              systemd.user.startServices = "sd-switch";
            }
          ];
        };
    in {
      # Overlayed packages
      overlay = (import ./overlays);

      # This repos plus any other overlays you use
      # If you want to use out-of-nixpkgs-tree packages, add their overlays here.
      overlays = [ self.overlay nur.overlay ];

      # System configurations
      # Accessible via 'nixos-rebuild --flake'
      nixosConfigurations = {
        cool-computer = mkSystem {
          hostname = "cool-computer";
          system = "x86_64-linux";
        };
        very-cool-computer = mkSystem {
          hostname = "very-cool-computer";
          system = "aarch64-linux";
        };
      };

      # Home configurations
      # Accessible via 'home-manager --flake'
      homeConfigurations = {
        "you@cool-computer" = mkHome {
          username = "you";
          hostname = "cool-computer";
          system = "x86_64-linux";
        };
        "you@very-cool-computer" = mkHome {
          username = "you";
          hostname = "very-cool-computer";
          system = "aarch64-linux";
        };
      };

      # Flakes templates you can access with 'nix flake init'
      templates = import ./templates;

    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = self.overlays; };
        hm = home-manager.defaultPackage."${system}";
      in {
        # Packages you can access with 'nix build'
        packages = {
          # Re-export nixpkgs' packages under the attribute "nixpkgs"
          # That way, you can test your overlays with 'nix build .#nixpkgs.package-name'
          nixpkgs = pkgs;
        # Export your custom packages. You can build them with 'nix build .#package-name'
        } // (import ./pkgs { inherit pkgs; });

        # Devshell you can access with 'nix develop'
        # Has nix and home-manager for bootstrapping
        # plus formatter and LSP for a nice editor experience
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nix nixfmt rnix-lsp hm ];
        };
      });
}
