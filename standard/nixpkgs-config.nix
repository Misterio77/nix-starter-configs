{ overlays, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    # Overlays is an attrset, convert to a list
    overlays = builtins.attrValues overlays;
  };
}
