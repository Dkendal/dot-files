#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
flake_dir="$(readlink -f "$script_dir/xdg_config/nix-darwin")"

# Initial nix-darwin command

nix run --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  nix-darwin -- \
  switch --flake "$flake_dir"
