{ pkgs ? import <nixpkgs> {} }:

let
  ubuntuBase = pkgs.dockerTools.pullImage {
    imageName = "ubuntu";
    imageDigest = "sha256:728785b59223d755e3e5c5af178fab1be7031f3522c5ccd7a0b32b80d8248123";
    hash = "sha256-l7jYaPQQ3JofKdfpe3oZYJKTM8zRc2NrtBDdhvlfyvU=";
    finalImageName = "ubuntu";
    finalImageTag = "noble-20250925";
  };
in

# Behaviorally equivalent replacement for .devcontainer/Dockerfile.
# This image explicitly starts from ubuntu:noble-20250925, then layers the
# requested tools and Nix on top via dockerTools.
pkgs.dockerTools.buildLayeredImageWithNixDb {
  name = "zmk-devcontainer-nix-base";
  tag = "latest";

  fromImage = ubuntuBase;

  contents = [
    pkgs.bashInteractive
    pkgs.cacert
    pkgs.coreutils
    pkgs.curl
    pkgs.git
    pkgs.nix
    pkgs.openssh
    pkgs.xz
  ];

  config = {
    # Use a stable profile symlink instead of a hashed /nix/store path.
    # This survives nixpkgs hash changes better when /nix is persisted as a volume.
    Cmd = ["/nix/var/nix/profiles/default/bin/bash"];
    Env = [
      "PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/usr/bin"
      "NIX_CONFIG=experimental-features = nix-command flakes"
    ];
  };
}
