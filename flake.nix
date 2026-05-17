{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ZMK environment definitions (build images, test images, dev shell).
    zmk-environments.url = "github:nmunnich/zmk-environments";
    zmk-environments.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    zmk-environments,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    mkDevShell = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      baseShell = zmk-environments.devShells.${system}.dev;

      # Add workspace-specific tools here.
      extraPackages = [];

      # Add workspace-specific environment variables here.
      extraEnv = {};

      # Add workspace-specific shell initialization here.
      extraShellHook = "";
    in
      pkgs.mkShellNoCC {
        inputsFrom = [baseShell];
        packages = extraPackages;
        env = extraEnv;
        shellHook = extraShellHook;
      };
  in {
    devShells = forAllSystems (system: {
      default = mkDevShell system;
    });
  };
}