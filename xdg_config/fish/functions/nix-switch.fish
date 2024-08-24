function nix-switch --description "rebuild the current profile"
	nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake (readlink -f ~/.config/nix-darwin)"#"$NIX_PROFILE
end
