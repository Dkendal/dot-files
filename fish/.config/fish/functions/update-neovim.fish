function update-neovim
	wget --follow-ftp --directory-prefix "~/Downloads" "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
	chmod u+x ~/Downloads/nvim.appimage
	mv ~/Downloads/nvim.appimage ~/bin/nvim
end
