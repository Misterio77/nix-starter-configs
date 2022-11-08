# A nixpkgs instance that is grabbed from the pinned nixpkgs commit in the lock file
# This is useful to avoid using channels when using legacy nix commands
let lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
in
import (fetchTarball {
  url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
  sha256 = lock.narHash;
})
