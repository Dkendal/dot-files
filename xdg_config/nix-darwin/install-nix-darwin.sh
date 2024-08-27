#!/usr/bin/env bash

if [ ! -f /etc/nix/nix.conf.before-nix-darwin ]; then
	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
fi

if [ ! -f /etc/shells.before-nix-darwin ]; then
	sudo mv /etc/shells /etc/shells.before-nix-darwin
fi

if [ ! -f /etc/bashrc.before-nix-darwin ]; then
	sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
fi

if [ ! -f /etc/zshrc.before-nix-darwin ]; then
	sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
fi

nix --extra-experimental-features flakes \
	 --extra-experimental-features nix-command \
	 run nix-darwin -- switch --flake "$( readlink ~/.config/nix-darwin )"
