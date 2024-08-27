#!/usr/bin/env bash

# Initial nix-darwin command

nix run --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  nix-darwin -- \
  switch --flake "$(readlink -f ~/dot-files/xdg_config/nix-darwin)"
