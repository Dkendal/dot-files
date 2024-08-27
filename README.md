# My Dotfiles

## Bootstrapping

Run the following scripts in order to bootstrap a new nix environment:

```bash
./download-nix-installer.sh
./nix-installer install
./nix-darwin-install.sh
./git-local-config.sh
# Apply the nix-darwin and home-manager configuration
./nix-switch.sh
```
