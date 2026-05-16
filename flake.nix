{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # This pins requirements.txt provided by zephyr-nix.pythonEnv.
    zephyr.url = "github:zmkfirmware/zephyr/v4.1.0+zmk-fixes";
    zephyr.flake = false;

    # Zephyr sdk and toolchain.
    zephyr-nix.url = "github:urob/zephyr-nix";
    zephyr-nix.inputs.zephyr.follows = "zephyr";
    zephyr-nix.inputs.nixpkgs.follows = "nixpkgs";

    # ZMK environment definitions (build images, test images, dev shell).
    zmk-environments.url = "path:./zmk-environments";
    zmk-environments.inputs.nixpkgs.follows = "nixpkgs";
    zmk-environments.inputs.zephyr.follows = "zephyr";
    zmk-environments.inputs.zephyr-nix.follows = "zephyr-nix";
  };

  outputs = {
    nixpkgs,
    zmk-environments,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (system: {
      default = zmk-environments.devShells.${system}.default;
    });
  };
}