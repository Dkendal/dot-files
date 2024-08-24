function rgz
	rg $argv --vimgrep --color ansi \
		 | fzf --ansi --delimiter : --preview '__fish_fzf_preview {1} {2} {3}'
end
