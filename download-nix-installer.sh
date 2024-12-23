#!/usr/bin/env bash
curl --proto '=https' --tlsv1.2 -sSf -o nix-installer -L https://install.determinate.systems/nix/tag/v0.26.3/nix-installer-aarch64-darwin
chmod u+x ./nix-installer
 
