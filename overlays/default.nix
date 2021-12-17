# Your overlays should go here (https://nixos.wiki/wiki/Overlays)
final: prev: {
  # example = prev.example.overrideAttrs (oldAttrs: rec {
  # ...
  # });
} // import ../pkgs { pkgs = final; }
# This line adds your custom packages into the overlay.
