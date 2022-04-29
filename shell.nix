# Shell for bootstrapping flake-enabled nix and home-manager, from any nix version
{ pkgs ? let
    inherit (builtins) currentSystem pathExists fromJSON readFile;

    nixpkgs =
      if pathExists ./flake.lock
      then
      # If we have a lock, fetch locked nixpkgs
        let
          inherit ((fromJSON (readFile ./flake.lock)).nodes.nixpkgs) locked;
        in
        fetchTarball {
          url = "https://github.com/nixos/nixpkgs/archive/${locked.rev}.tar.gz";
          sha256 = locked.narHash;
        }
      else
      # If not (probably because not flake-enabled), fetch nixos-unstable impurely
        fetchTarball {
          url = "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
        };

    system = currentSystem;
    overlays = [ ];

  in
  import nixpkgs { inherit system overlays; }
, ...
}:
let
  # Enable experimental features without having to specify the argument
  nix = pkgs.writeShellScriptBin "nix" ''
    exec ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
  '';
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ nix home-manager git ];
}
