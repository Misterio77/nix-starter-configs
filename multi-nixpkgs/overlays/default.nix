{ inputs, ... }:
# This file defines overlays
{
  # Sets `unstable` under `pkgs` as the nixpkgs unstable channel
  unstable = final: _prev: {
    unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
  };

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
