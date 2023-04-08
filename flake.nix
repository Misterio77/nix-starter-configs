{
  description = "NixOS + standalone home-manager config flakes to get you started!";
  outputs = inputs: {
    templates = {
      minimal = {
        description = ''
          Minimal flake - contains only the configs.
          Contains the bare minimum to migrate your existing legacy configs to flakes.
        '';
        path = ./minimal;
      };
      minimal-nixosonly = {
        description = ''
          Similar to the minimal, but with only NixOS (not home-manager).
        '';
        path = ./minimal-nixosonly;
      };
      standard = {
        description = ''
          Standard flake - augmented with boilerplate for custom packages, overlays, and reusable modules.
          Perfect migration path for when you want to dive a little deeper.
        '';
        path = ./standard;
      };
    };
  };
}
