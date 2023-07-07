function p
	set -l root (ghq root)
	set -l dir (
		for l in (ghq list)
			set -l dir $root/$l/.git
			set -l branch " "

			if test -d $dir
				set branch (git -C $dir symbolic-ref -q --short HEAD)
			else if test -f $dir
				set gitdir (cat $dir | awk '/gitdir:/ {print $2}')
				set branch (git --git-dir $gitdir --work-tree $dir symbolic-ref -q --short HEAD)
			end

			echo $l\t$branch

		end | column -t -s \t | fzf | awk '{print $1}'
	)

	echo $dir

	if test $status -eq 0
		cd $root/$dir
	end
end
