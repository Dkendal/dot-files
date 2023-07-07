function ea
	set -l height 10
	set -l fzf_opts "--height" "$height" "--cycle"

	fd Earthfile -x dirname |
		string trim |
		fzf --prompt "Earthfile > " --select-1 $fzf_opts |
		read dir
	or return

	env -C $dir earthly ls |
		fzf --prompt "Target ($dir) > " $fzf_opts |
		read target
	or return

	echo earthly --verbose ./$dir$target
	earthly --verbose ./$dir$target
end
