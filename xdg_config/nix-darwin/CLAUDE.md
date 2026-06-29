# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a nix-darwin configuration repository for macOS system management using Nix flakes. It manages system packages, user environment, and dotfile configurations through declarative configuration files.

## Key Files

- `flake.nix` - Main Nix flake defining system configuration, packages, and dependencies
- `home.nix` - Home Manager configuration for user-specific settings and dotfiles
- `Taskfile.yml` - Task runner configuration with common development commands

## System Architecture

The configuration supports two machine profiles:
- `Titania` (personal computer) - user: `dylan`
- `dylankendal-mbp` (work computer) - user: `dylan.kendal`

Both configurations use the same base configuration function but with different users and specialArgs.

## Common Commands

### System Management
- `task switch` - Apply nix-darwin configuration changes (rebuilds and switches system)
- `task update` - Update flake inputs to latest versions
- `task clean` - Clean old generations (30+ days old)
- `task lsg` - List system generations
- `task edit` - Edit the main flake.nix file

### Nix Operations
- `nix flake update` - Update all flake inputs
- `nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake ./` - Manual system switch
- `sudo nix-collect-garbage --delete-older-than 30d` - Clean old generations

## Configuration Structure

### Package Management
System packages are defined in `flake.nix` under `environment.systemPackages`. The configuration includes comprehensive tooling for:
- Development (git, neovim, language servers)
- Shell utilities (nushell, fish, zsh)
- Container tools (docker, colima)
- Data processing (jq, duckdb, ripgrep)
- Security tools (gnupg, trufflehog)

### Home Manager Integration
User-specific configurations are managed through Home Manager in `home.nix`, including:
- XDG config file symlinks to `~/dot-files/xdg_config/`
- Program configurations (direnv, gh, fzf, starship)
- Shell integrations and development tools (mise)

### Homebrew Integration
Additional packages not available in nixpkgs are managed through Homebrew with automatic cleanup enabled.

## Development Workflow

1. Edit configuration files (`flake.nix` or `home.nix`)
2. Run `task switch` to apply changes
3. Use `task clean` periodically to remove old generations
4. Run `task update` to update dependencies when needed

## Important Notes

- The configuration assumes the dotfiles repository is cloned to `~/dot-files`
- XDG config files are symlinked from the dotfiles directory
- The system uses experimental Nix features (flakes and nix-command)
- TouchID authentication is enabled for sudo
- Automatic garbage collection runs weekly