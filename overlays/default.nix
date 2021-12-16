# Your overlays should go here
final: prev: {
  # example = prev.example.overrideAttrs (oldAttrs: rec {
  # ...
  # });
} // import ../pkgs { pkgs = final; }
# This line adds your custom packages to the overlay.
