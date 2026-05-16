{
  description = "Standalone flake for devcontainer images";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = ["x86_64-linux" "aarch64-linux"];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          devcontainer-parity-image = import ./dockerfile-parity-image.nix { inherit pkgs; };
          default = import ./dockerfile-parity-image.nix { inherit pkgs; };
        }
      );
    };
}