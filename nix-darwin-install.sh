#!/usr/bin/env bash

set -euxo pipefail

if [ -f /etc/nix/nix.conf ]; then
	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
fi

nix 	--extra-experimental-features nix-command \
	--extra-experimental-features flakes \
	run nix-darwin -- switch --flake ./xdg_config/nix-darwin
