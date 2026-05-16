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
  };

  outputs = {
    nixpkgs,
    zephyr-nix,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        zephyr = zephyr-nix.packages.${system};
      in {
        default = pkgs.mkShellNoCC {
          packages =
            [
              zephyr.pythonEnv
              (zephyr.sdk-0_16.override {targets = ["arm-zephyr-eabi"];})

              # Core build tools (zmk-docker: common/build)
              pkgs.ccache
              pkgs.cmake
              pkgs.dtc
              pkgs.docker
              pkgs.file
              pkgs.gcc
              pkgs.git
              pkgs.gnumake
              pkgs.gperf
              pkgs.ninja
              pkgs.openssh
              pkgs.protobuf
              pkgs.python3
              pkgs.python3Packages.pip
              pkgs.python3Packages.setuptools
              pkgs.python3Packages.wheel

              # Dev tools (zmk-docker: dev)
              pkgs.caCertificates
              pkgs.clang-tools
              pkgs.curl
              pkgs.gdb
              pkgs.gnupg
              pkgs.less
              pkgs.nano
              pkgs.nodejs_20
              pkgs.SDL2
              pkgs.socat
              pkgs.tio
              pkgs.wget
              pkgs.xz

              # -- Used by just_recipes and west_commands. Most systems already have them. --
              # pkgs.gawk
              # pkgs.unixtools.column
              # pkgs.coreutils # cp, cut, echo, mkdir, sort, tail, tee, uniq, wc
              # pkgs.diffutils
              # pkgs.findutils # find, xargs
              # pkgs.gnugrep
              # pkgs.gnused
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
              # Matches locales in Ubuntu-based dev images.
              pkgs.glibcLocales
            ]
            ++ pkgs.lib.optionals (system == "x86_64-linux") [
              # Mirrors gcc-multilib in the Docker image when available.
              pkgs.gcc_multi
            ];

          env = {
            PYTHONPATH = "${zephyr.pythonEnv}/${zephyr.pythonEnv.sitePackages}";
          };

          shellHook = ''
            export ZMK_BUILD_DIR=$(pwd)/.build;
            export ZMK_SRC_DIR=$(pwd)/zmk/app;
          '';
        };
      }
    );
  };
}