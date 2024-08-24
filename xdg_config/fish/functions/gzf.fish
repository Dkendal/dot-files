function gzf -a file
	function help
		echo "usage: gzf <file>"
	end

	# echo $file
	if ! string match '^\.\/'
		set file "./$file"
	end

	set -l show "--no-pager show --minimal --patch --pretty=short --color=always"

	set -l delta_opts "--relative-paths --hyperlinks --paging never --features side-by-side=false"

	set -l preview '
		if [ "$(expr length {1})" = 8 ]; then
			hash={1}
		elif [ "$(expr length {2})" = 8 ]; then
			hash={2}
		elif [ "$(expr length {3})" = 8 ]; then
			hash={3}
		else
			echo "n/a"
			exit 0
		fi

		if [ -n "$hash" ]; then
			git '$show' $hash '$file' | delta '$delta_opts'
		fi
	'

	if [ -z "$file" ]
		help
		return 1
	end


	set -l format "%C(yellow)%h%C(reset) %s %C(blue)(%S)%Creset"

	set -l change "reload:args={q}; git log \$args --color=always --all --pretty='$format' -- '$file' || :"

	git log --graph --color=always --all --pretty="$format" -- "$file" |
	fzf --ansi --disabled --preview "$preview" --bind "change:$change"
end
