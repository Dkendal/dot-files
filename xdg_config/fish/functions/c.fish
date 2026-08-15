function c --description "cd to a jj/git repo under a root dir" --argument-names root
    test -n "$root" || set -f root ~/src

    set -l dir (
        fd --hidden --prune --type dir '^\.(jj|git)$' $root --format '{//}' \
            | awk '!seen[$0]++ { print; fflush() }' \
            | fzf --prompt 'repo> '
    )

    test -n "$dir" || return 1
    cd $dir
end
