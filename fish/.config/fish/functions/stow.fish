function stow --wraps stow
	command stow $argv 2>&1 |
		colout "^LINK:.*" "green" |
		colout "^\\-\\-\\-.*" "blue" |
		colout "^ERROR:.*" "red" |
		colout "^WARNING:.*" "yellow"
end
