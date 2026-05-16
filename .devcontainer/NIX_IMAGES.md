# Nix-based alternatives to Dockerfile

This directory now has its own flake, so you can treat `.devcontainer` as a
standalone Nix entrypoint.

The image definition provided is:

- `dockerfile-parity-image.nix`: explicitly starts from `ubuntu:noble-20250925`, then adds the Dockerfile-equivalent tooling via Nix

## Build and load the parity image

```bash
cd .devcontainer
nix build .#devcontainer-parity-image
docker load < result
```

## Build from the parent directory

If you stay at the repo root, you can target the nested flake directly:

```bash
nix build ./.devcontainer#devcontainer-parity-image
docker load < result
```

## Direct file builds

If you want to evaluate the files directly, these also work:

```bash
nix build --file .devcontainer/dockerfile-parity-image.nix
```

## Use in devcontainer.json

Replace:

```json
"dockerFile": "Dockerfile"
```

with:

```json
"image": "zmk-devcontainer-parity:latest"
```

The existing mounts/postStartCommand can stay as-is.
