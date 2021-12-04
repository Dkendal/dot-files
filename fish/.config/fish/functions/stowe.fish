function stowe \
    --description "Edit a file owned by stow"

    stowls | fzf --bind "enter:execute($EDITOR $STOW_DIR/{})"
end
