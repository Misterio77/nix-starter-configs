# Shell for bootstrapping flake-enabled nix and home-manager, from any nix version
{ pkgs ? let
    system = builtins.currentSystem or "Unknown system";

    nixpkgs =
      if builtins.pathExists ./flake.lock
      then
      # If we have a lock, fetch locked nixpkgs
        let lock = builtins.fromJSON (builtins.readFile ./flake.lock).nodes.nixpkgs.locked;
        in
        fetchTarball {
          url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
          sha256 = lock.narHash;
        }
      else
      # If not (probably because not flake-enabled), fetch nixos-unstable impurely
        fetchTarball {
          url = "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
        };

  in
  import nixpkgs { inherit system; }
, ...
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ nix home-manager git ];
}
