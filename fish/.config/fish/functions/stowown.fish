function stowown \
    --description 'Move SOURCE into TARGET module in $STOW_DIR' \
    --argument-names target source

    argparse 'n/dry-run' 'h/help' -- $argv

    if [ -n "$_flag_help" ]
        echo "\
usage: stow-own TARGET SOURCE [ -h | --help ] [ -n | --dry-run ]
"
        return 0
    end

    set targetpath "$STOW_DIR/$target/$source"

    if [ ! -r "$source" ]
        echo "Error: '$source' is not a readable file"
        return 1
    end

    if [ -z "$STOW_DIR" ]
        echo 'Error: $STOW_DIR not set'
        return 1
    end

    switch "$target"
        case ""
            echo "Error: TARGET is empty"
            return 1
        case "/"
            echo "Error: refusing to copy root"
            return 1
    end

    if [ -e "$targetpath" ]
        echo "Error: "$targetpath" already exists"
        return 1
    end

    if [ -n "$_flag_dry_run" ]
        set rsync_opts "-n"
    else
        mkdir -p (dirname "$targetpath")
    end

    rsync -aivub --no-links --remove-source-files $rsync_opts "$source" "$targetpath"
end

complete -c stow-own -n '[ 1 = (commandline | wc -w) ]' -d TARGET -xa '(ls -d $STOW_DIR/*/ | xargs -L1 basename)'
