function rgi -w rg
	set -la rg_opts "--color=always" "--vimgrep"
	set -x SHELL dash
	set -l syntax_map '*.rkt:Lisp'

	set -l min 'x = ({2} - $FZF_PREVIEW_LINES / 2); if (x > 0) x else 0'

	set -l max 'x = ({2} + $FZF_PREVIEW_LINES / 2); y = $LINES; if (x > y) x else y'

	set -l preview '
		[ -z {1} ]
		&& echo "n/a"
		|| bat {1}
			--map-syntax '$syntax_map'
			--force-colorization
			--paging never
			--style snip
			--highlight-line {2}
			--line-range
			$(echo "'$min'" | tr -d "\'" | bc):$(echo "'$max'" | tr -d "\'" | bc)
	'

	set -l preview (string replace --all --regex '[\t\n]+' ' ' $preview)

	begin
		if [ -n "$argv" ]
			rg $argv $rg_opts
		else
		  echo ''
		end
	end | fzf --disabled --query "$argv" --multi --ansi \
	--delimiter ':' \
	--preview $preview \
	--bind 'alt-a:toggle-all' \
	--bind 'ctrl-j:execute(echo \# query: {q})+execute(cat {+f})+execute(echo)' \
	--bind "change:reload:[ -n {q} ] && eval rg {q} $rg_opts || echo"
end


