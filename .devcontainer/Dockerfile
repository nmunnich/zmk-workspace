FROM docker.io/zmkfirmware/zmk-dev-arm:4.1-branch

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		docker.io \
		ca-certificates \
		curl \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm --init none
RUN mkdir -p /etc/nix \
	&& printf '%s\n' 'experimental-features = nix-command flakes' > /etc/nix/nix.conf

ENV PATH=/nix/var/nix/profiles/default/bin:${PATH}

COPY .bashrc tmp
RUN mv /tmp/.bashrc ~/.bashrc
