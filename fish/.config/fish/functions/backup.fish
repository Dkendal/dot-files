function backup
	restic backup \
		--verbose=1 \
		--exclude-file $HOME/.config/restic/excludes.txt \
		--repo /media/dylan/DK-USB/restic-repo \
		~/.config ~/src ~/notes
end
