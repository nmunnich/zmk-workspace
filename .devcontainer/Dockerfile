FROM ubuntu:noble-20250925

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    openssh-client \
    xz-utils \
  && curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
  | sh -s -- install linux --init none --no-confirm \
  && rm -rf /var/lib/apt/lists/*

ENV PATH=/nix/var/nix/profiles/default/bin:${PATH}
